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

<#if !cp?has_content>
    {
        "infoMessages": [],
        "warningMessages": [],
        "errorMessages": [{"ourCode": "VENDOR_INVALID_RESPONSE"}]
    }
<#elseif cp.ErrorInfo?has_content && cp.ErrorInfo?length gt 0>
    {
        "infoMessages": [],
        "warningMessages": [],
        "errorMessages": [{
            "ourCode": "VENDOR_RATING_GENERAL",
            "message": "${cp.ErrorInfo!""}"
        }] 
    }
<#else>
    {
        <#--  nisam siguran za dohvatanje ove 4 vrednosti, kako izgleda cp -->
        "rateQuotes":[{ 
            "status": "true", 
            "quote_num": ${cp.QuoteNumber!},
            "billed": "347.48",
            "transit_time": ${(cp.TransitDays)!0},

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