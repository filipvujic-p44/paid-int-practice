<#compress>

<#assign p44 = interactionRecords[0].requestBody>

<#function hasContent node>
    <#return node?? && node?has_content && node?trim?has_content && node!=null>
</#function>

<#--  Resolve phone number value from contact info  -->
<#function buildPhoneNumber phoneNumberObject phoneNumberString>
    <#--  If phoneNumber2 exists, return that value  -->
    <#if phoneNumberString?has_content>
        <#return phoneNumberString>
    </#if>
    <#--  Try to build a string from phoneNumber json node  -->
    <#if phoneNumberObject?has_content && phoneNumberObject.areaCode?has_content && phoneNumberObject.centralOfficeCode?has_content && phoneNumberObject.stationCode?has_content>
        <#return phoneNumberObject.areaCode + "-" + phoneNumberObject.centralOfficeCode + "-" + phoneNumberObject.stationCode>
    <#else>
        <#return "">
    </#if>
</#function>

<#function resolvePaymentTerms paymentTerms>
    <#if paymentTerms?has_content && paymentTerms?lower_case == "collect" || paymentTerms?lower_case == "c">
        <#return "COL">
    <#--  If paymentTerms has no content, return PPD  -->
    <#else>
        <#return "PPD">
    </#if>
</#function>

<#function convertTimeFormat time>
    <#if (time)!?has_content>
    <#assign hours = time?split(':')[0]>
    <#assign minutes = time?split(':')[1]>
        <#return hours + ':' + minutes>
    </#if>
</#function>

<#--  MAPPING  -->
<#list p44.shipmentIdentifiers as identifier>
    <#if identifier.type == "BILL_OF_LADING">
        <#assign bol = identifier.value>
    </#if>
    <#if identifier.type == "PURCHASE_ORDER">
        <#assign ponum = identifier.value>
    </#if>
</#list>

{
    "pickup_date": "${(p44.pickupWindow.date)!}",
    "ready_by_time": "${convertTimeFormat(p44.pickupWindow.startTime)!}",
    "closing_time": "${convertTimeFormat(p44.pickupWindow.endTime)!}",
    "shipper_name": "${(p44.originLocation.contact.companyName)!}",
    "shipper_address": "${(p44.originLocation.address.addressLines[0])!}",
    "shipper_city": "${(p44.originLocation.address.city)!}",
    "shipper_state": "${(p44.originLocation.address.state)!}",
    "shipper_zip": "${(p44.originLocation.address.postalCode)!}",
    "shipper_contact": "${(p44.originLocation.contact.email)!}",
    "shipper_phone": "${buildPhoneNumber((p44.originLocation.contact.phoneNumber)!, (p44.originLocation.contact.phoneNumber2)!)}",
    "consignee_name": "${(p44.destinationLocation.contact.companyName)!}",
    "consignee_address": "${(p44.destinationLocation.address.addressLines[0])!}",
    "consignee_city": "${(p44.destinationLocation.contact.city)!}",
    "consignee_state": "${(p44.destinationLocation.contact.state)!}",
    "consignee_zip": "${(p44.destinationLocation.contact.postalCode)!}",
    "consignee_contact": "${(p44.destinationLocation.contact.email)!}",
    "consignee_phone": "${buildPhoneNumber((p44.destinationLocation.contact.phoneNumber)!, (p44.destinationLocation.contact.phoneNumber2)!)}",
    "bol": "${bol!}",
    "ponum": "${ponum!}",
    "quote_num": "${(p44.quoteNumber)!0}",
    "comments": "${(p44.deliveryNote)!}",

    "line_items": [
        <#list p44.lineItems as item>
            {
            "pallets": ${(item.totalPackages)!0},
            "length": ${(item.packageDimensions.length)!0},
            "width": ${(item.packageDimensions.width)!0},
            "height": ${(item.packageDimensions.height)!0},
            "weight": ${(item.totalWeight)!0},
            "stackable": "${(item.stackable?string("true", "false"))!}",
            "freight_class_code": "${(item.freightClass)!}",
            "packageType": "${(item.packageType)!}",
            "description": "${(item.description)!}"
            }
        <#sep>,
    </#list>
    ],
    "accessorial_charges": [
        <#assign accessorials = p44.directlyCodedAccessorialServices + p44.indirectlyCodedAccessorialServices>
        <#list accessorials as acc>
            {
                "type": "${(acc.code)!}"
            }
            <#sep>,
        </#list>
    ]
}
</#compress>