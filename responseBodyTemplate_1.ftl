<#compress>
    <#setting number_format="computer">
    <#setting time_zone="America/Chicago">
    <#include "p44TrackingResponseMacros.ftl">

    <#attempt>
        <#assign cp = interactionRecords[0].vendorResponseBody>
        <#assign cpString = interactionRecords[0].vendorResponseBodyString?trim>
        <#recover>
            <#assign cp = "">
    </#attempt>
    <#assign p44 = interactionRecords[0].requestBody>

    <#if !cpString?has_content >
        <@error ourCode="VENDOR_INVALID_RESPONSE"/>
    <#elseif cp.error_msg?has_content>
        <@error ourCode="VENDOR_TRACKING_GENERAL" message= cp.error_msg/>
    <#else>
        <#assign shipmentIdentifiers = [{"type":p44.shipmentIdentifier.type, "value":p44.shipmentIdentifier.value}]>
            {
            "responseType": "INGESTION_EVENT",
            "data": [
            <#list cp.TracingEvents as event >
                ${event?is_first?string("", ",")}
                <@ingestionEvent
                scac="RTTA"
                shipmentIdentifiers=(shipmentIdentifiers)!
                statusCode=(event.status)!
                description=(event.comment)!
                />
            </#list>
            ]
            }
    </#if>
</#compress>