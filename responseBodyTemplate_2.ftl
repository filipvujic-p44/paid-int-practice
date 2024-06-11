<#compress>
<#setting number_format="computer">

<#attempt>
	<#assign cp0 = interactionRecords[0].vendorResponseBody>
	<#assign cp0String = interactionRecords[0].vendorResponseBodyString>
<#recover>
	<#assign cp0 = "">
	<#assign cp0String = "">
</#attempt>

<#attempt>
    <#assign cp1 = interactionRecords[1].vendorResponseBody>
	<#assign cp1String = interactionRecords[1].vendorResponseBodyString>
<#recover>
    <#assign cp1 = "">
	<#assign cp1String = "">
</#attempt>

<#function hasContent node>
	<#return node?? && node?has_content && node?trim?has_content>
</#function>


<#if !cp1String?has_content || !cp0String?has_content>
	{
		"infoMessages": [],
		"warningMessages": [],
		"errorMessages": [{
			"ourCode": "VENDOR_INVALID_RESPONSE",
			"message": ""
		}]
	}
<#elseif cp1.status != true >
	{
		"rateQuotes": [],
		"infoMessages": [],
		"warningMessages": [],
		"errorMessages": [{
			"ourCode": "VENDOR_DISPATCH_GENERAL",
			"message": "${(cp1.error_msg)!}"
		}]
	}
<#elseif cp0.status != true >
	{
		"rateQuotes": [],
		"infoMessages": [],
		"warningMessages": [],
		"errorMessages": [{
			"ourCode": "VENDOR_DISPATCH_GENERAL",
			"message": "${(cp0.error_msg)!}"
		}]
	}
<#else>
{  
	"shipmentIdentifiers": [
		{
			"type": "CUSTOMER_REFERENCE",
			"value": "${(cp1.shipment_id)!}"
		}
	],
	"shipmentConfirmationDetail":{
		"originLocation":{
			"address":{
				"addressLines": [],
				"city": null,
				"state": null,
				"postalCode": "${(cp0.origin_zip)!}",
				"country": null
			},
			"contact":{
				"companyName": null,
				"contactName": null,
				"email": null,
				"phoneNumber": null,
				"phoneNumber2": null,
				"faxNumber": null
			},
			"destinationLocation":{
				"address":{
					"addressLines": [],
					"city": null,
					"state": null,
					"postalCode": "${(cp0.destination_zip)!}",
					"country": null
				},
				"contact":{
					"companyName": null,
					"contactName": null,
					"email": null,
					"phoneNumber": null,
					"phoneNumber2": null,
					"faxNumber": null
				}
			},
			"transitDays": "${(cp0.transit_days)!}"
			
		}
	},
	"infoMessages": [],
	"warningMessages": [],
	"errorMessages": []
}
</#if>
</#compress>