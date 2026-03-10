@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Taxi Booking Root View'
define root view entity ZI_TAXIBOOKING_083
  as select from ztaxi_book_083
  association [1..1] to ZI_TAXIDRIVER_083 as _Driver on $projection.DriverId = _Driver.DriverId
{
  key booking_uuid          as BookingUuid,
      booking_id            as BookingID, 
      customer_name         as CustomerName,
      pickup_location       as PickupLocation,
      drop_location         as DropLocation,
      driver_id             as DriverId,
      vehicle_number        as VehicleNumber,
      status                as Status,
      
      /* --- ADDED CAST: Forces the type to match the Draft Table (INT1) --- */
      cast( case status
        when 'Booked'          then 2  // Yellow
        when 'Driver Assigned' then 1  // Blue
        when 'Trip Started'    then 2  // Orange
        when 'Completed'       then 3  // Green
        else 0
      end as abap.int1 )    as StatusCriticality,
      
      booking_date          as BookingDate,
      fare_amount           as FareAmount,
      currency_code         as CurrencyCode,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      local_last_changed_at as LocalLastChangedAt,
      _Driver
}
