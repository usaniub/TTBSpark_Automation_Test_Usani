*** Settings ***
Library                RequestsLibrary
Library                JSONLibrary
Library                String
Library                SeleniumLibrary




*** Variables ***
${G_url}                 https://reqres.in/api/users/

${userName}                      ${None}
${G_expected_ID}                 12
${G_expected_email}              rachel.howell@reqres.in
${G_expected_Fname}              Rachel
${G_expected_Lname}              Howell
${G_expected_Avatar}             https://reqres.in/img/faces/12-image.jpg


*** Keywords ***

Send Get Request To API and Verify Response
    [Arguments]    ${userName}    ${expected_status}    
    ${response}=    GET    ${G_url}${userName}    verify=${False}    expected_status=${expected_status}
    ${response_code}=    Convert To String    ${response.status_code}
    ${response_body}=    Set Variable    ${response.json()}
    
    IF    '${response_code}' == '200'
       Log To Console    Code Response = ${response_code}${\n}
        # Get Json value from Json response body
       ${API_ID}=    Get Value from Json Response Body    ${response_body}    $.data.id
       ${API_Email}=    Get Value from Json Response Body    ${response_body}    $.data.email
       ${API_Fname}=    Get Value from Json Response Body    ${response_body}    $.data.first_name
       ${API_Lname}=    Get Value from Json Response Body    ${response_body}    $.data.last_name
       ${API_Avatar}=    Get Value from Json Response Body    ${response_body}    $.data.avatar

        # Verify API response VS Expected Result
        Verify API Response VS Expected Result    ${API_ID}    ${G_expected_ID}
        Verify API Response VS Expected Result    ${API_Email}    ${G_expected_email}
        Verify API Response VS Expected Result    ${API_Fname}    ${G_expected_Fname}
        Verify API Response VS Expected Result    ${API_Lname}    ${G_expected_Lname}
        Verify API Response VS Expected Result    ${API_Avatar}    ${G_expected_Avatar}

    ELSE IF    '${response_code}' == '404'
        Log To Console    Code Response = ${response_code}${\n}
        ${response_body_txt}=    Convert To String    ${response_body}
        
        ${verify_response}=    Run Keyword And Return Status    Should Match Regexp    ${response_body_txt}    \{\}
        
    END


Get Value from Json Response Body
    [Arguments]    ${Json_body}    ${Json_path}
    ${response_value_Json}=    Get Value From Json    ${Json_body}    ${Json_path}
    ${response_value_str}=    Convert To String    ${response_value_Json}
    ${response_value}=    Remove String Using Regexp    ${response_value_str}    \\[|'|]
    
    Return From Keyword    ${response_value}



Verify API Response VS Expected Result
    [Arguments]    ${API_response_value}    ${Expected_value}
    ${Compare_Result}=    Run Keyword And Return Status    Should Be Equal    ${API_response_value}    ${Expected_value}
    IF    '${Compare_Result}' == 'True'
        Log To Console    PASS : Response from API and expected result are the same. ${\n} API Response : ${API_response_value} = Expected Result : ${Expected_value} ${\n}
    ELSE
        Log To Console    FAIL : Response from API and expected result are not the same. ${\n} API Response : ${API_response_value} = Expected Result : ${Expected_value} ${\n}
        Run Keyword And Continue On Failure    Fail    FAIL : Response from API and expected result are not the same.
    END




*** Test Cases ***

TC1:Get user profile success
    [Documentation]    To verify get user profile api will return correct data when trying to get profile of existing user
    [Tags]    TC1    ALLTC
    Send Get Request To API and Verify Response    12    200

TC2:Get user profile but user not found
    [Tags]    TC2    ALLTC
    Send Get Request To API and Verify Response    1234    404