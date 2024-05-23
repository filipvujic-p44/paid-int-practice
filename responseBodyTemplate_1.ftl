<#compress>
<#setting number_format="computer">

<#attempt >
    <#assign cp = interactionRecords[0].vendorResponseBody>
	<#assign cpString = interactionRecords[0].vendorResponseBodyString>
    <#recover >
        <#assign cp = "">
		<#assign cpString = "">
</#attempt>

<#attempt>
	<#assign cpStatus = interactionRecords[0].vendorResponseHttpStatus>
<#recover>
	<#assign cpStatus = "">
</#attempt>

<#function hasContent node>
	<#return node?? && node?has_content && node?trim?has_content>
</#function>


<#if !hasContent(cpString)>
	{
		"infoMessages": [],
		"warningMessages": [],
		"errorMessages": [{
			"ourCode": "VENDOR_INVALID_RESPONSE",
			"message": ""
		}]
	}
<#elseif !(${(cp.status)!})>
	{
		"rateQuotes": [],
		"infoMessages": [],
		"warningMessages": [],
		"errorMessages": [{
			"ourCode": "VENDOR_DISPATCH_GENERAL",
			"message": "${(cp.error_msg)!}"
		}]
	}
<#else>
{  
	"shipmentIdentifiers": [
		{
			"type": "CUSTOMER_REFERENCE",
			"value": "${(cp.shipment_id)!}"
		}
	],
	"shipmentConfirmationDetail": {
		"pickupWindow": {},
		"originLocation":{
			"address":{
				"addressLines": [
					""
				],
				"city": "",
				"state": "",
				"postalCode": "",
				"country": ""
			},
			"contact":{
				"contactName": "",
				"phoneNumber": ""
			}
		},
		"originTerminal": {},
		"destinationLocation":{
			"address":{
				"addressLines": [
					""
				],
				"city": "",
				"state": "",
				"postalCode": "",
				"country": ""
			},
			"contact":{
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
		"appliedQuote": {}
	},
	"infoMessages": [],
	"warningMessages": [],
	"errorMessages": []
}
</#if>
</#compress>