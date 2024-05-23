<#compress>
<#assign p44 = interactionRecord[0].requestBody>
<#function hasContent node>
    <#return node?has_content && node?trim != "">
</#function>
<#function extractPhoneNumber contact="">
    <#if contact.phoneNumber?has_content>
        <#if hasContent(contact.phoneNumber.areaCode) && 
             hasContent(contact.phoneNumber.centralOfficeCode) &&
             hasContent(contact.phoneNumber.stationCode)>
            <#return contact.phoneNumber.areaCode?trim+"-"+contact.phoneNumber.centralOfficeCode?trim+"-"+contact.phoneNumber.stationCode?trim>
        </#if>
    </#if>
    <#return contact.phoneNumber2!"">
</#function>

<#function formatTime time>
    <#if time?has_content>
        <#local hours = time?split(":")[0]>
        <#local minutes = time?split(":")[1]>
        <#return hours + ":" + minutes + "h">
    </#if>
    <#return "">    
</#function>

<#function BOL_value identifiers = "">
    <#if identifiers?has_content>
        <#list identifiers as item>
            <#if item.type == "BILL_OF_LADING">
                <#return item.value>
            </#if>     
        </#list>
    </#if>
    <#return "">
</#function>

<#function PONUM_value identifiers>
    <#if identifiers?has_content>
        <#list identifiers as item>
            <#if item.type == "PURCHASE_ORDER">
                <#return item.value>
            </#if>
        </#list>
    <#return "">
</#function>
{
    "pickup_date": "${(p44.pickupWindow.date)}",
    "ready_by_time": "${(formatTime(p44.requesterLocation.pickupWindow.startTime)!)!}",<#-- convert time -->
    "closing_time": "${(formatTime(p44.requesterLocation.pickupWindow.endTime)!)!}",<#-- convert time -->
    "shipper_name": "${(p44.originLocation.contact.companyName)!}",
    "shipper_address": "${(p44.originLocation.address.addressLines[0])!}",
    "shipper_city": "${(p44.originLocation.address.city)!}",
    "shipper_state": "${(p44.originLocation.address.state)!}",
    "shipper_zip": "${(p44.originLocation.address.postalCode)!}",
    "shipper_contact": "${(p44.originLocation.address.contact.email)!}",
    "shipper_phone": "${extractPhoneNumber((p44.originLocation.contact)!)!}",<#-- napravi fju da konvertuje -->
    "consignee_name": "${(p44.destinationLocation.contact.companyName)!}",
    "consignee_address": "${(p44.destinationLocation.address.addressLines[0])!}",
    "consignee_city": "${(p44.destinationLocation.address.city)!}",
    "consignee_state": "${(p44.destinationLocation.address.state)!}",
    "consignee_zip": "${(p44.destinationLocation.address.postalCode)!}",
    "consignee_contact": "${(p44.destinationLocation.contact.email)!}",
    "consignee_phone": "${extractPhoneNumber((p44.destinationLocation.contact)!)!}",<#-- napravi fju da konvertuje -->
    "bol": "${(BOL_value(p44.shipmentIdentifiers))!}",<#-- ${(p44.shipmentIdentifiers[0].value)!} -->
    "ponum": "${(PONUM_value(p44.shipmentIdentifiers))!}",<#-- ${(p44.shipmentIdentifiers[1].value)!} -->
    "quote_num": ${(p44.quoteNumber)!},
    "comments": "${(p44.pickupNote)!}",
   
    "line_items": [
        <#list p44.lineItems as item>
            {
                "pallets": "${(item.totalPackages)!0}",
                "length": "${(item.packageDimensions.length)!0}",
                "width": "${(item.packageDimensions.width)!0}",
                "height": "${(item.packageDimensions.height)!0}",
                "weight": "${(item.totalWeight)!0}",
                "stackable": "${(item.stackable)!}",
                "freight_class_code": "${(item.freightClass)!}",
                "packageType": "${(item.packageType)!}",
                "description": "${(item.description)!}"
            }<#sep>,
            <#rt>
        </#list>
    ]
    <#assign accessorials = p44.directlyCodedAccessorialServices + p44.indirectlyCodedAccessorialServices>
    "accessorial_charges": [
        <#list accessorials as item>
            {
                "type": "${(accessorials.code)!}"
            }<#sep>,
            <#rt>
        </#list>
    ]
}
</#compress>
