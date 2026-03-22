@AccessControl.authorizationCheck: #MANDATORY
@Metadata.allowExtensions: true
@ObjectModel.sapObjectNodeType.name: 'ZRAP_PK_TRAVEL'
@EndUserText.label: '###GENERATED Core Data Service Entity'
define root view entity ZR_RAP_PK_TRAVEL
  as select from zrap_pk_travel association [0..1] to /DMO/I_Agency as _Agency on $projection.AgencyID = _Agency.AgencyID
                                association [0..1] to /DMO/I_Customer as _customer on $projection.CustomerID = _customer.CustomerID
                                association [1..1] to /DMO/I_Overall_Status_VH as _Overallstatus on $projection.OverallStatus = _Overallstatus.OverallStatus
                                association [0..1] to I_Currency  as _currency on $projection.CurrencyCode = _currency.Currency
{


key  travel_id as TravelID,
   key  travel_uuid as travel_uuid,
  agency_id as AgencyID,
  customer_id as CustomerID,
  begin_date as BeginDate,
  end_date as EndDate,
  @Semantics.amount.currencyCode: 'CurrencyCode'
  booking_fee as BookingFee,
  @Semantics.amount.currencyCode: 'CurrencyCode'
  total_price as TotalPrice,
  @Consumption.valueHelpDefinition: [ {
    entity.name: 'I_CurrencyStdVH', 
    entity.element: 'Currency', 
    useForValidation: true
  } ]
  currency_code as CurrencyCode,
  description as Description,
  overall_status as OverallStatus,
  
  @Semantics.largeObject: {
      mimeType: 'MimeType',
      fileName: 'FileName',
      acceptableMimeTypes: [ 'image/png','image/jpeg' ],
      contentDispositionPreference: #ATTACHMENT
    
  }
  attachment as Attachment,
  
  @Semantics.mimeType: true
  mime_type as MimeType,
  
  file_name as FileName,
  @Semantics.user.createdBy: true
  created_by as CreatedBy,
  @Semantics.systemDateTime.createdAt: true
  created_at as CreatedAt,
  @Semantics.user.localInstanceLastChangedBy: true
  local_last_changed_by as LocalLastChangedBy,
  @Semantics.systemDateTime.localInstanceLastChangedAt: true
  local_last_changed_at as LocalLastChangedAt,
  @Semantics.systemDateTime.lastChangedAt: true
  last_changed_at as LastChangedAt,
  _Agency,
  _currency,
  _customer,
  _Overallstatus
}
