<#compress>

<#attempt>
	<#assign cp1 = interactionRecords[0].vendorResponseBody>
	<#assign cp1String = interactionRecords[0].vendorResponseBodyString>
	<#assign fetchedTransitTime = cp1.TransitDays>
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

<#function parseTimeFormat node>
	<#if node?trim?has_content>
		<#return node?trim + ":00">
	<#else>
		<#return "">
	</#if>
</#function>

<#if !cp2?has_content || !hasContent(cp2String)>
	{
		"shipmentIdentifiers": [],
		"shipmentConfirmationDetail":{},
		"infoMessages": [],
		"warningMessages": [],
		"errorMessages": [{
			"ourCode": "VENDOR_INVALID_RESPONSE",
			"message": ""
		}
		]
	}

<#elseif hasContent(cp2.error_msg!)>
	{
		"shipmentIdentifiers": [],
		"shipmentConfirmationDetail":{},
		"infoMessages": [],
		"warningMessages": [],
		"errorMessages": [{
			"ourCode": "VENDOR_DISPATCH_GENERAL",
			"message": "${(cp2.error_msg)!}"
			}
		]
	}

<#else>
	{
		"shipmentIdentifiers": [
			{
				"type": "CUSTOMER_REFERENCE",
				"value": "${(cp2.shipment_id)!}"
			}
		],
		"shipmentConfirmationDetail":{},
		"infoMessages": [],
		"warningMessages": [],
		"errorMessages": []
	}
</#if>

</#compress>