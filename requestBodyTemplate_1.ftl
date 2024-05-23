<#compress>
<#assign p44 = interactionRecords[0].requestBody>

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
    "ready_by_time": "${(p44.deliveryWindow.startTime)!?keep_before_last(":")}h",
    "closing_time": "${(p44.deliveryWindow.endTime)!?keep_before_last(":")}h",
    "shipper_code": null,
    "shipper_name": "${(p44.originLocation.contact.contactName)!}",
    "shipper_address": "${(p44.originLocation.address.addressLines[0])!}",
    "shipper_city": "${(p44.originLocation.address.city)!}",
    "shipper_state": "${(p44.originLocation.address.state)!}",
    "shipper_zip": "${(p44.originLocation.address.postalCode)!}",
    "shipper_contact": "${(p44.originLocation.contact.email)!}",
    "shipper_phone": "${extractPhoneNumber((p44.originLocation.contact)!)!}",
    "consignee_code": null,
    "consignee_name": "${(p44.destinationLocation.contact.contactName)!}",
    "consignee_address": "${(p44.destinationLocation.address.addressLines[0])!}",
    "consignee_city": "${(p44.destinationLocation.address.city)!}",
    "consignee_state": "${(p44.destinationLocation.address.state)!}",
    "consignee_zip": "${(p44.destinationLocation.address.postalCode)!}",
    "consignee_contact": "${(p44.destinationLocation.contact.email)!}",
    "consignee_phone": "${extractPhoneNumber((p44.destinationLocation.contact)!)!}",
    "bol": "${bol!}",
    "ponum": "${ponum!}",
    "quote_num": "${(p44.quoteNumber)!}",
    "cod_amount_in_cents": 0,
    "comments": "${(p44.deliveryNote)!}",
    "line_items": [
        {
            "pallets": "${(p44.lineItems.totalPackages)!0}",
            "length": "${(p44.lineItems.packageDimensions.length)!0.0}",
            "width": "${(p44.lineItems.packageDimensions.width)!0.0}",
            "height": "${(p44.lineItems.packageDimensions.height)!0.0}",
            "weight": "${(p44.lineItems.totalWeight)!0}",
            "stackable": "${(p44.lineItems.stackable)!}",
            "freight_class_code": "${(p44.lineItems.freightClass)!}",
            "packageType": "${(p44.lineItems.packageType)!}",
            "description": "${(p44.lineItems.description)!}",
        }
    ],
    "accessorial_charges": [
        <#assign list = p44.directlyCodedAccessorialServices + p44.indirectlyCodedAccessorialServices>
        <#if list?has_content>
        <#list list as acc>
            {
                "type":"${(acc.code)!}"
            }<#sep>,
            <#rt>
        </#list>
    ]
}

</#compress>