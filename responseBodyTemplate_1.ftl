<#compress>
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

<#--  ova funkcija je visak, kad kopiras stvari od nekud, proveri sta se stvarno koristi i pobrisi visak  -->
<#function resolveServiceCode node>
	<#if node?has_content>
		<#if node == "Standard">
			<#return "STD">
		<#elseif node == "Guaranteed">
			<#return "GUR">
		</#if>
	<#else>
		<#return "">
	</#if>
</#function>

<#if !hasContent(cpString)>
	{
		"rateQuotes": [],
		<#--  ne vracamo ovo polje freighthubu, ne treba da se stavlja  -->
        "status":"${(cp.status)!}"
		"infoMessages": [],
		"warningMessages": [],
		"errorMessages": [{
			"ourCode": "VENDOR_INVALID_RESPONSE",
			"message": ""
		}]
	}
	<#--  only removed for local testing  -->
<#elseif !(${(cp.status)!})>
	{
		"rateQuotes": [],
		<#--  ne vracamo ovo polje freighthubu, ne treba da se stavlja  -->
        "status":"${(cp.status)!}"
		"infoMessages": [],
		"warningMessages": [],
		"errorMessages": [{
			"ourCode": "VENDOR_RATING_GENERAL",
			"message": "${(cp.message)!}"
		}]
	}
<#else>
    {
        "rateQuotes":[
            {
                "carrierCode":"RTTA",
                "quoteNumber":"${(cp.quote_num)!0}",
                "serviceLevel":{},
                "transitDays":"${(cp.transit_time)!0}",
                "deliveryDateTime":{},
                "rateQuoteDetail":{
                    "total":"${(cp.billed)!0.0}",
                    "charges":[]
                },
                "alternateRateQuotes":[],
                "originTerminal":{},
                "destinationTerminal":{},
                "quoteEffectiveDateTime":{},
                "quoteExpirationDateTime":{},
                "unacceptedAccessorialServiceCodes":[],
                "infoMessages":[],
                "warningMessages":[],
                "errorMessages":[]
            }
        ],
		<#--  ne vracamo ovo polje freighthubu, ne treba da se stavlja  -->
        "status":"${(cp.status)!}"     <!-- not sure if this field should be here -->
        "infoMessages":[],
        "warningMessages":[],
        "errorMessages":[]
    }

</#if>
</#compress>