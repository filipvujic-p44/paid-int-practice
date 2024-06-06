<#compress>
<#attempt>
	<#assign cp0 = interactionRecords[0].vendorResponseBody>
	<#assign cp0String = interactionRecords[0].vendorResponseBodyString>
<#recover>
	<#assign cp0 = "">
	<#assign cp0String = "">
</#attempt>

<#if !cp0String?has_content>
{
	"shipmentIdentifiers": [],
	"shipmentConfirmationDetail":{},
	"infoMessages": [],
	"warningMessages": [],
	"errorMessages": [{
		"ourCode": "VENDOR_DISPATCH_GENERAL",
		"message": "Error processing first interaction."
	}]
}
<#else>
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
</#if>
</#compress>