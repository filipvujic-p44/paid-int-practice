<#compress>

    <#assign p44 = interactionRecords[0].requestBody>
    <#attempt>
        <#assign cp = interactionRecords[0].vendorResponseBody>
        <#assign cpString = interactionRecords[0].vendorResponseBodyString>
    <#recover>
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

<#function parseTimeFormat node>
	<#if node?trim?has_content>
		<#return node?trim + ":00">
	<#else>
		<#return "">
	</#if>
</#function>

<#--  MAPPING  -->
<#--  Error Case - empty response  -->
<#if !cp?has_content || !hasContent(cpString)>
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
<#--  Error Case - returned error message  -->
<#elseif hasContent(cp.error_msg!)>
	{
		"shipmentIdentifiers": [],
		"shipmentConfirmationDetail":{},
		"infoMessages": [],
		"warningMessages": [],
		"errorMessages": [{
			"ourCode": "VENDOR_DISPATCH_GENERAL",
			"message": "${(cp.error_msg)!}"
			}
		]
	}
<#--  Success Case  -->
<#else>
	{
		"shipmentIdentifiers": [
			{
				"type": "CUSTOMER_REFERENCE",
				"value": "${(cp.shipment_id)!}"
			}
		],
		"shipmentConfirmationDetail":{},
		"infoMessages": [],
		"warningMessages": [],
		"errorMessages": []
	}
</#if>

</#compress>