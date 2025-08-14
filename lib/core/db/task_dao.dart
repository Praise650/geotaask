import 'package:floor/floor.dart';

import '../enums/marker_status.dart';
import '../model/marker_entity.dart';
import '../model/user_entity.dart';

@dao
abstract class TaskDao {
  @Query("SELECT * FROM user_entity")
  Future<UserEntity?> getUserProfile();

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> saveUser(UserEntity data);

  // Create a geofence marker
  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> createGeofenceMarker(MarkerEntity entity);

  // Fetch all geofence markers
  @Query("SELECT * FROM geofences")
  Stream<List<MarkerEntity>> getGeofenceMarkers();

  // Fetch all geofence markers
  @Query("SELECT * FROM geofences")
  Future<List<MarkerEntity>> fetchGeofenceMarkers();

  // Fetch geofence marker by id
  @Query("SELECT * FROM geofences WHERE id = :id")
  Future<MarkerEntity?> getGeofenceMarkerById(int id);

  // Fetch geofence marker by markerId
  @Query("SELECT * FROM geofences WHERE markerId = :markerId")
  Future<MarkerEntity?> getGeofenceMarkerByMarkerId(String markerId);

  @Query("SELECT * FROM geofences WHERE status = :status")
  Future<List<MarkerEntity>?> fetchGeofenceMarkerByStatus(MarkerStatus status);

  // Delete all geofence markers
  @Query("DELETE FROM geofences")
  Future<void> deleteGeofenceMarkers();

  // Delete geofence marker by id
  @Query("DELETE FROM geofences WHERE id = :id")
  Future<void> deleteGeofenceMarkerId(int id);

  // Delete geofence marker by markerId
  @Query("DELETE FROM geofences WHERE markerId = :markerId")
  Future<void> deleteGeofenceMarkerByMarkerId(String markerId);

  // Update geofence marker
  @Update()
  Future<void> updateGeofenceMarker(MarkerEntity entity);
}

  // @Insert(onConflict: OnConflictStrategy.replace)
  // Future<void> saveWallet(List<WalletEntity> data);
  //
  // @Query(
  //     "select * from (select *, CAST(wallet_id AS INTEGER) as mod_id from wallet_transaction where status = :status) as A order by A.mod_id desc")
  // Stream<List<WalletEntity>> getWalletList(String status);
  //
  // @Query("select * from user_bank_entity where active = :status")
  // Stream<List<UserBankEntity>> getUserBanks(String status);
  //
  // @Insert(onConflict: OnConflictStrategy.replace)
  // Future<void> saveMyBankList(List<UserBankEntity> data);
  //
  // @delete
  // Future<void> deleteMyBank(UserBankEntity userBankEntity);
  //
  // @Insert(onConflict: OnConflictStrategy.replace)
  // Future<void> saveBankList(List<BankEntity> data);
  //
  // @Query(
  //     "select * from bank_entity where active = :status order by bank_name asc")
  // Stream<List<BankEntity>> getBankList(String status);
  //
  // @Insert(onConflict: OnConflictStrategy.replace)
  // Future<void> saveSettings(List<SettingsEntity> data);
  //
  // @Insert(onConflict: OnConflictStrategy.replace)
  // Future<void> saveSubProduct(List<SubProductEntity> data);
  //
  // @Query("select * from settings_entity where settings_id = :settings_id")
  // Stream<SettingsEntity?>? getSettingsById(String settings_id);
  //
  // @Query("select * from payment_account_entity where active = :active")
  // Stream<List<PaymentAccountEntity>> getPaymentBanks(String active);
  //
  // @Insert(onConflict: OnConflictStrategy.replace)
  // Future<void> savePaymentAcct(List<PaymentAccountEntity> data);
  //
  // @Insert(onConflict: OnConflictStrategy.replace)
  // Future<void> saveProducts(List<ProductEntity> data);
  //
  // @Query(
  //     "select * from product_entity where active = :active and service_id = :serviceId order by product_id asc")
  // Stream<List<ProductEntity>> getProductsByServiceId(
  //     String active, String serviceId);
  //
  // @Query(
  //     "select * from (select *, CAST(sub_price as INTEGER) as mod_price from sub_product_entity where product_id = :prodId and active = :active) as S order by S.mod_price asc")
  // Stream<List<SubProductEntity>> getSubProductByProdId(
  //     String prodId, String active);
  //
  // @Query(
  //     "select * from product_entity where active = :active and instruction2 = :instruction2 order by product_id asc")
  // Stream<List<ProductEntity>> getPayBillsByCategory(
  //     String active, String instruction2);
  //
  // @Insert(onConflict: OnConflictStrategy.replace)
  // Future<void> saveReferral(ReferralEntity data);
  //
  // @Query(
  //     "select * from referral_entity where email = :email and active = :active")
  // Stream<ReferralEntity?> getReferralCode(String email, String active);
  //
  // @Query("select * from voucher_entity order by created_at desc limit 100")
  // Stream<List<VoucherEntity>> getTransactionList();
  //
  // @Insert(onConflict: OnConflictStrategy.replace)
  // Future<void> saveHistory(List<VoucherEntity> data);
  //
  // @Insert(onConflict: OnConflictStrategy.replace)
  // Future<void> saveFaq(List<FaqEntity> data);
  //
  // @Query(
  //     "select faq_cat from faq_entity where active = :active group by faq_cat ")
  // Stream<List<FaqEntity>> getFaqsCats(String active);
  //
  // @Query(
  //     "select * from faq_entity where faq_cat = :faqCat and active = :active")
  // Stream<List<FaqEntity>> getFaqsByCat(String faqCat, String active);
  //
  // @Insert(onConflict: OnConflictStrategy.replace)
  // Future<void> saveMyReferrals(List<MyReferralsEntity> data);
  //
  // @Query("select * from my_referrals_entity")
  // Stream<List<MyReferralsEntity>> getMyReferrals();
  //
  // @Query(
  //     "select * from (select *, CAST(sub_price as decimal) as casted from sub_product_entity where active = :active and CAST(sub_price as decimal) > 0.0 ) as A order by A.product_id, A.casted")
  // Stream<List<SubProductEntity>> getMyPrices(String active);
  //
  // @Insert(onConflict: OnConflictStrategy.replace)
  // Future<void> saveDataBalCodes(List<DataBalEntity> data);
  //
  // @Query("select * from data_balance_entity where active = :active")
  // Stream<List<DataBalEntity>> getDataBalCodes(String active);
  //
  // @Query("select * from settings_entity")
  // Stream<List<SettingsEntity>> getSettings();
  //
  // @Insert(onConflict: OnConflictStrategy.replace)
  // Future<void> saveSupports(List<SupportEntity> data);
  //
  // @Query(
  //     "select * from support_entity where active = :active order by un_read desc, support_id desc")
  // Stream<List<SupportEntity>> getSupports(String active);
  //
  // @Query(
  //     "select * from reply_entity where active = :active and support_id = :support_id order by reply_id asc")
  // Stream<List<ReplyEntity>> getReplies(String active, String support_id);
  //
  // @Query(
  //     "update support_entity set un_read = :un_read where support_id = :support_id")
  // Future<void> markThreadAsRead(String un_read, String support_id);
  //
  // @Insert(onConflict: OnConflictStrategy.replace)
  // Future<void> saveTicketReply(List<ReplyEntity> data);
  //
  // @Insert(onConflict: OnConflictStrategy.replace)
  // Future<void> saveTicketReplies(List<ReplyEntity> data);
  //
  // @Query("select * from notification_entity where active = :active")
  // Stream<List<NotificationEntity>> getNotifications(String active);
  //
  // @Insert(onConflict: OnConflictStrategy.replace)
  // Future<void> saveNotification(NotificationEntity notificationEntity);
  //
  // @Query(
  //     "select sum(CAST(un_read as INTEGER)) as counter from support_entity where active = :active")
  // Stream<NotificationEntity?> unreadSupportReply(String active);
  //
  // @Query(
  //     "select COUNT (message) as counter from notification_entity where read = :read and active = :active")
  // Stream<NotificationEntity?> unreadNotificationCount(
  //     String read, String active);
  //
  // @Query("delete from user_bank_entity")
  // Future<void> deleteMyBankList();
  //
  // @Query("delete from wallet_transaction")
  // Future<void> deleteWalletHistory();
  //
  // @Query("delete from my_referrals_entity")
  // Future<void> deleteMyReferrals();
  //
  // @Query("delete from voucher_entity")
  // Future<void> deleteHistory();
  //
  // @Query("delete from support_entity")
  // Future<void> deleteMySupportTicket();
  //
  // @Query("delete from reply_entity")
  // Future<void> deleteMyReplies();
