<#compress>
<#setting number_format="computer">

<#attempt>
	<#assign cp1 = interactionRecords[0].vendorResponseBody>
	<#assign cp1String = interactionRecords[0].vendorResponseBodyString>
	<#assign fetchedTransitTime = (cp1.TransitDays)!>
<#recover>
	<#assign cp1 = "">
	<#assign fetchedTransitTime = "">
</#attempt>

<#attempt>
	<#assign cp2 = interactionRecords[1].vendorResponseBody>
	<#assign cp2String = interactionRecords[1].vendorResponseBodyString>
<#recover>
	<#assign cp2 = "">
</#attempt>

<#function hasContent node>
	<#return node?? && node?has_content && node?trim?has_content>
</#function>

<#if !hasContent(cp1String) || !hasContent(cp2String)>
	{
		"shipmentIdentifiers": [],
		"shipmentConfirmationDetail": {},
		"infoMessages": [],
		"warningMessages": [],
		"errorMessages": [{
			"ourCode": "VENDOR_INVALID_RESPONSE",
			"message": ""
		}]
	}
<#elseif cp2.status != true>
	{
		"shipmentIdentifiers": [],
		"shipmentConfirmationDetail": {},
		"infoMessages": [],
		"warningMessages": [],
		"errorMessages": [{
			"ourCode": "VENDOR_DISPATCH_GENERAL",
			"message": "${(cp2.error_msg)!}"
		}]
	}
<#else>
{  
	"shipmentIdentifiers": [
		{
			"type": "CUSTOMER_REFERENCE",
			"value": "${(cp2.shipment_id)!}"
		}
	],
	"shipmentConfirmationDetail": {
		"pickupWindow": {},
		"originLocation": {
			"address": {
				"addressLines": [
					""
				],
				"city": "",
				"state": "",
				"postalCode": "${cp1.origin_zip}",
				"country": ""
			},
			"contact": {
				"contactName": "",
				"phoneNumber": ""
			}
		},
		"originTerminal": {},
		"destinationLocation": {
			"address": {
				"addressLines": [
					""
				],
				"city": "",
				"state": "",
				"postalCode": "${cp1.destination_zip}",
				"country": ""
			},
			"contact": {
				"contactName": "",
				"phoneNumber": ""
			} 
		},
		"billToLocation": {
			"address": {
			"addressLines": []
			},
			"contact": {}
		},
		"serviceLevel": {},
		"appliedQuote": {},
		"transitDays": ${fetchedTransitTime!}
	},
	"infoMessages": [],
	"warningMessages": [],
	"errorMessages": []
}
</#if>
</#compress>