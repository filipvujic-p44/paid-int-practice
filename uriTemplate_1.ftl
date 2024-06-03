<#compress>
<#assign p44 = interactionRecords[0].requestBody>
    https://rtta/api/v1/shipment/transitdays?originzip={originLocation.postalCode}&destinationzip={destinationLocation.postalCode}&pickupdate={pickupWindow.date}
</#compress>