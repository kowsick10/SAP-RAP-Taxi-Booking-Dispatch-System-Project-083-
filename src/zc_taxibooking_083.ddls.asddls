@EndUserText.label: 'Taxi Booking Projection'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
define root view entity ZC_TAXIBOOKING_083
  provider contract transactional_query
  as projection on ZI_TAXIBOOKING_083
{
    key BookingUuid,
    BookingID,
    CustomerName,
    PickupLocation,
    DropLocation,

    /* Linking to the now-active Driver Projection */
    @Consumption.valueHelpDefinition: [{ 
        entity: { name: 'ZC_TAXIDRIVER_083', element: 'DriverId' },
        useForValidation: true 
    }]
    DriverId,
    
    VehicleNumber,
    Status,
    StatusCriticality, 
    BookingDate,
    
    @Semantics.amount.currencyCode: 'CurrencyCode'
    FareAmount,
    CurrencyCode,
    
    LocalLastChangedAt,
    
    /* Redirection now works because ZC_TAXIDRIVER_083 exists and is a root */
    _Driver : redirected to ZC_TAXIDRIVER_083
}
