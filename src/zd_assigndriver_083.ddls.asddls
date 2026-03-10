@EndUserText.label: 'Assign Driver Parameter'
define abstract entity ZD_ASSIGNDRIVER_083
{
  /* Value Help Link to Driver Master View */
  @Consumption.valueHelpDefinition: [{ 
      entity: { name: 'ZI_TAXIDRIVER_083', element: 'DriverId' },
      useForValidation: true 
  }]
  
  @EndUserText.label: 'Select Driver'
  DriverId : abap.char(10);
  
  /* You could optionally add a 'Remarks' field here if needed */
  // @EndUserText.label: 'Assignment Remarks'
  // Remarks  : abap.char(100);
}
