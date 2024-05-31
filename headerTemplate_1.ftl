<#compress>
    <#assign p44 = interactionRecords[0].requestBody>
    {
        "api-key":"${(p44.vendorAuthentication.credential2)!}"
    }
</#compress>