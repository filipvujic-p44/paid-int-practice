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

<#if !hasContent(cpString)>
	{
		"infoMessages": [],
		"warningMessages": [],
		"errorMessages": [{
			"ourCode": "VENDOR_INVALID_RESPONSE",
			"message": ""
		}]
	}
	<#--  only removed for local testing  -->
<#elseif $(cp.status) != true>
	{
		"infoMessages": [],
		"warningMessages": [],
		"errorMessages": [{
			"ourCode": "VENDOR_RATING_GENERAL",
			"message": "${(cp.error_msg)!}"
		}]
	}
<#else>
    {
        "rateQuotes":[{
            "carrierCode": "RTTA",
            "quoteNumber": ${cp.quote_num!},
            "serviceLevel": {},
            "transitDays": ${(cp.transit_time)!0},
            "deliveryDateTime": {
                "dateTime": ""
            },
            "rateQuoteDetail":{
                "total": ${cp.billed!},
            },
            "alternateRateQuotes":[],
            "originTerminal":{},
            "destinationTerminal":{},
            "quoteEffectiveDateTime": {},
            "quoteExpirationDateTime":{},
            "unacceptedAccessorialServiceCodes":[],

            "infoMessages":[],
            "warningMessages":[],
            "errorMessages":[]
        }],
        "infoMessages":[],
        "warningMessages":[],
        "errorMessages":[]
    }
</#if>
</#compress>