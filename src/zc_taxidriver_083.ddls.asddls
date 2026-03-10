@EndUserText.label: 'Driver Projection View'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
@Search.searchable: true
define root view entity ZC_TAXIDRIVER_083
  provider contract transactional_query
  as projection on ZI_TAXIDRIVER_083
{
    @Search.defaultSearchElement: true
    key DriverId,
    @Search.defaultSearchElement: true
    DriverName,
    PhoneNumber,
    VehicleNumber,
    AvailabilityStatus,
    
    /* --- FIXED: No more 'CASE' here, just the field name --- */
    StatusCriticality, 
    
    LocalLastChangedAt
}
