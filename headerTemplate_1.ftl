<#compress>
    <#assign p44 = interactionRecords[0].requestBody> 

{
    "Content-Type": "application/json",
    "Accept": "application/json",
    "api-key": "${(p44.vendorAuthentication.credential2)!}"
}

</#compress>