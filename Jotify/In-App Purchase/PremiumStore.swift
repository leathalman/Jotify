//
//  PremiumStore.swift
//  Jotify
//
//  StoreKit 2 replacement for the old SKPaymentQueue-based IAPManager.
//

import StoreKit

/// Owns the one-time "Jotify Premium" purchase. StoreKit verifies
/// transactions on device; a verified purchase also flips `hasPremium` in
/// the user's Firestore settings, which is what the rest of the app reads.
@MainActor
final class PremiumStore: ObservableObject {

    static let shared = PremiumStore()
    static let productID = "com.austinleath.Jotify.Premium"

    @Published private(set) var product: Product?
    @Published private(set) var isLoadingProduct = false

    private var updatesTask: Task<Void, Never>?

    private init() {}

    /// Call once at launch: listens for transactions that finish outside a
    /// purchase call (Ask to Buy approvals, purchases on another device,
    /// refunds).
    func start() {
        guard updatesTask == nil else { return }
        updatesTask = Task.detached(priority: .background) {
            for await result in Transaction.updates {
                await PremiumStore.shared.handle(result)
            }
        }
    }

    func loadProduct() async {
        guard product == nil, !isLoadingProduct else { return }
        isLoadingProduct = true
        defer { isLoadingProduct = false }
        do {
            product = try await Product.products(for: [Self.productID]).first
        } catch {
            print("StoreKit: couldn't load products: \(error)")
        }
    }

    enum PurchaseOutcome {
        case purchased, pending, cancelled
    }

    func purchase() async throws -> PurchaseOutcome {
        if product == nil { await loadProduct() }
        guard let product else { throw StoreError.productUnavailable }

        switch try await product.purchase() {
        case .success(let verification):
            let transaction = try checked(verification)
            grantPremium()
            await transaction.finish()
            return .purchased
        case .pending:
            // Ask to Buy: the approval arrives later through Transaction.updates.
            return .pending
        case .userCancelled:
            return .cancelled
        @unknown default:
            return .cancelled
        }
    }

    /// Syncs with the App Store (may ask for the Apple Account password),
    /// then checks entitlements. Returns whether Premium was found.
    func restore() async throws -> Bool {
        try await AppStore.sync()
        return await refreshEntitlement()
    }

    /// Grants Premium if StoreKit already lists a verified, unrevoked
    /// purchase. Silent: no password prompt.
    @discardableResult
    func refreshEntitlement() async -> Bool {
        for await result in Transaction.currentEntitlements {
            if case .verified(let transaction) = result,
               transaction.productID == Self.productID,
               transaction.revocationDate == nil {
                grantPremium()
                return true
            }
        }
        return false
    }

    private func handle(_ result: VerificationResult<Transaction>) async {
        guard case .verified(let transaction) = result else { return }
        if transaction.productID == Self.productID, transaction.revocationDate == nil {
            grantPremium()
        }
        await transaction.finish()
    }

    private func checked<T>(_ result: VerificationResult<T>) throws -> T {
        switch result {
        case .verified(let value): return value
        case .unverified(_, let error): throw error
        }
    }

    private func grantPremium() {
        UserDefaults.standard.set(true, forKey: "hasPremium")
        guard !(User.settings?.hasPremium ?? false) else { return }
        User.settings?.hasPremium = true
        DataManager.updateUserSettings(setting: "hasPremium", value: true) { success in
            if success != true { print("Error updating Firestore when enabling premium") }
        }
    }

    enum StoreError: LocalizedError {
        case productUnavailable
        var errorDescription: String? {
            "Jotify Premium isn't available right now. Check your connection and try again."
        }
    }
}
