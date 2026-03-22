@Metadata.allowExtensions: true
@EndUserText: {
  label: '###GENERATED Core Data Service Entity'
}
@ObjectModel: {
  sapObjectNodeType.name: 'ZRAP_PK_TRAVEL',
  semanticKey: [ 'TravelID' ]

}

@AccessControl.authorizationCheck: #MANDATORY

define root view entity ZC_RAP_PK_TRAVEL
  provider contract transactional_query
  as projection on ZR_RAP_PK_TRAVEL
  association [1..1] to ZR_RAP_PK_TRAVEL as _BaseEntity
   on $projection.TravelID = _BaseEntity.TravelID
   and $projection.travel_uuid= _BaseEntity.travel_uuid
                
{



  key  TravelID as TravelID,
     key  travel_uuid as travel_uuid,

//  key TravelID,


      @ObjectModel.text.element: [ 'agencyName' ]
      AgencyID,
      _Agency.Name        as agencyName,

      @ObjectModel.text.element: [ 'customerName' ]
      CustomerID,
      _customer.FirstName as customerName,


      BeginDate,
      EndDate,
      @Semantics: {
        amount.currencyCode: 'CurrencyCode'
      }
      BookingFee,
      @Semantics: {
        amount.currencyCode: 'CurrencyCode'
      }
      TotalPrice,
      @Consumption: {
        valueHelpDefinition: [ {
          entity.element: 'Currency',
          entity.name: 'I_CurrencyStdVH',
          useForValidation: true
        } ]
      }
      CurrencyCode,
      Description,
      OverallStatus,
 
      Attachment,


      MimeType,
      FileName,
      @Semantics: {
        user.createdBy: true
      }
      CreatedBy,
      @Semantics: {
        systemDateTime.createdAt: true
      }
      CreatedAt,
      @Semantics: {
        user.localInstanceLastChangedBy: true
      }
      LocalLastChangedBy,
      @Semantics: {
        systemDateTime.localInstanceLastChangedAt: true
      }
      LocalLastChangedAt,
      @Semantics: {
        systemDateTime.lastChangedAt: true
      }
      LastChangedAt,
      _BaseEntity
}
