<#compress>
<#attempt>
	<#assign cp0 = interactionRecords[0].vendorResponseBody>
	<#assign cp0String = interactionRecords[0].vendorResponseBodyString>
<#recover>
	<#assign cp0 = "">
	<#assign cp0String = "">
</#attempt>
{
	"shipmentIdentifiers": [],
	"shipmentConfirmationDetail":{},
	"infoMessages": [],
	"warningMessages": [],
	"errorMessages": [{
		"ourCode": "VENDOR_DISPATCH_GENERAL",
		"message": "Error processing 2nd interaction."
	}]
}
</#compress>