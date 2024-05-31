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

    <#if !cp?has_content || !p44?has_content>
        <@error ourCode="VENDOR_INVALID_RESPONSE" message=""/>
    
    <#elseif cp.status != true>
        <@error ourCode="VENDOR_TRACKING_GENERAL" message=cp.error_msg/>
    
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
                description=(event.comment)!""
                <#-- scheduled date - now function -->
                />
            </#list>
        ]
        }
    </#if>
</#compress>