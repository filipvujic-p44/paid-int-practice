<#compress>
<#setting number_format="computer">

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


<#if !hasContent(cp1String)>
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
<#else>
{  
	"shipmentIdentifiers": [
		{
			"type": "CUSTOMER_REFERENCE",
			"value": "${(cp1.shipment_id)!}"
		}
	],
	"shipmentConfirmationDetail": {},
	"infoMessages": [],
	"warningMessages": [],
	"errorMessages": []
}
</#if>
</#compress>