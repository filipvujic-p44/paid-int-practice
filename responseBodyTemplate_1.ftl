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
    
    <#--  treba proveriti slucajeve kada je request neuspesan. Te slucajeve, za divno cudo, nisam uspeo da proizvedem u postmenu  -->
    
    <#--  <#elseif cp.code?has_content>
        <#if cp.code=="internal_server_error" >
            <@error ourCode="VENDOR_TIMEOUT" message=cp.message!""/>
        <#elseif cp.code=="request_unauthorized" >
            <@error ourCode="VENDOR_AUTH" message=cp.message!""/>
        <#elseif cp.code=="invalid_field_data" >
            <@error ourCode="VENDOR_INVALID_SHIPMENT_IDENTIFIER" message=cp.message!""/>
        <#else>
            <@error ourCode="VENDOR_INVALID_RESPONSE" message=cp.message!""/>
         </#if>  -->
    
    <#else>
        <#assign shipmentIdentifiers = [{"type":p44.shipmentIdentifier.type, "value":p44.shipmentIdentifier.value}]>
        {
        "responseType": "INGESTION_EVENT",
        "data": [
        <#list cp as event >
            ${event?is_first?string("", ",")}
            <@ingestionEvent
            scac="MMCV"
            statusCode=(event.status)!
            shipmentIdentifiers=(shipmentIdentifiers)!
            timestamp=removeMilisecundsFromDatetime((event.pickup_date)!"1970-01-01T00:00:00Z")!?datetime("yyyy-MM-dd'T'HH:mm:ss'Z'")?long?c
            description=(event.statusDescription)!""    <!-- not sure how to map -->
            city=(event.shipper_info.city)!""
            <#--  country=(event.shipper_info)!""  -->
            state=(event.shipper_info.state)!""
            postalCode=(event.shipper_info.zip)!""
            estimateTimestamp=removeMilisecundsFromDatetime((event.scheduled_date)!"1970-01-01T00:00:00Z")!?datetime("yyyy-MM-dd'T'HH:mm:ss'Z'")?long?c
            <#--  lat=(event.shipperLat)!"0"  -->
            <#--  lon=(event.shipperLong)!"0"  -->
            />
        </#list>

        ]
        }
    </#if>
</#compress>