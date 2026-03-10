@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Driver Master View'
define root view entity ZI_TAXIDRIVER_083 as select from ztaxi_driv_083
{
  key driver_id as DriverId,
  driver_name as DriverName,
  phone_number as PhoneNumber,
  vehicle_number as VehicleNumber,
  availability_status as AvailabilityStatus,
  
  /* --- MOVE LOGIC HERE: Logic for Colors (Criticality) --- */
  case availability_status
    when 'Available' then 3  // Green
    when 'Busy'      then 1  // Red
    else 0
  end as StatusCriticality,
  
  @Semantics.systemDateTime.localInstanceLastChangedAt: true
  local_last_changed_at as LocalLastChangedAt
}
