<#compress>
    <#setting number_format="computer">
    <#include "p44TrackingResponseMacros.ftl">
    <#attempt>
        <#assign cp = interactionRecords[0].vendorResponseBody>
        <#recover>
            <#assign cp = "">
    </#attempt>
    <#assign p44 = interactionRecords[0].requestBody>

    <#function hasContent node>
	    <#return node?? && node?has_content && node?trim?has_content>
    </#function>

    <#function removeMilisecundsFromDatetime datetime="1970-01-01T00:00:00Z">
       <#if hasContent(datetime)>
            <#if datetime?contains(".")>
                <#assign dotIndex = datetime?index_of(".")>
                <#return datetime?substring(0, dotIndex) + 'Z'> 
            </#if>
        </#if>
        <#return datetime>
    </#function> 


    <#if !cp?has_content >
        <@error ourCode="VENDOR_INVALID_RESPONSE" message=""/>
    <#elseif cp.status != true>
        <@error ourCode="VENDOR_TRACKING_GENERAL" message=cp.error_msg!""/>
    <#else>
        <#assign shipmentIdentifiers = [{"type":p44.shipmentIdentifier.type, "value":p44.shipmentIdentifier.value}]>
        {
        "responseType": "INGESTION_EVENT",
        "data": [
        <#list cp.tracing_events as event >
            ${event?is_first?string("", ",")}
            <@ingestionEvent
            scac="RTTA"
            statusCode=(event.status)!
            shipmentIdentifiers=(shipmentIdentifiers)!
            timestamp=removeMilisecundsFromDatetime((cp.pickup_date)!"1970-01-01T00:00:00Z")!?datetime("yyyy-MM-dd'T'HH:mm:ss'Z'")?long?c
            description=(event.comment)!""
            city=(cp.shipper_info.city)!""
            state=(cp.shipper_info.state)!""
            postalCode=(cp.shipper_info.zip)!""
            estimateTimestamp=removeMilisecundsFromDatetime((cp.scheduled_date)!"1970-01-01T00:00:00Z")!?datetime("yyyy-MM-dd'T'HH:mm:ss'Z'")?long?c
            />
        </#list>

        ]
        }
    </#if>
</#compress>