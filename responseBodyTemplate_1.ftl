<#compress>

<#attempt>
	<#assign cp1 = interactionRecords[0].vendorResponseBody>
	<#assign cp1String = interactionRecords[0].vendorResponseBodyString>
<#recover>
	<#assign cp1 = "">
</#attempt>

<#function hasContent node>
	<#return node?? && node?has_content && node?trim?has_content>
</#function>

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