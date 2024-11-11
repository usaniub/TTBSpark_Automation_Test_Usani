*** Settings ***
Library               SeleniumLibrary
Library               String

Test Teardown    Close All Browsers




*** Variables ***
${G_weburl}                          http://the-internet.herokuapp.com/login
${G_usn_input}                       //*[@name='username']
${G_pwd_input}                       //*[@name='password']
${G_submit_btn}                      //*[@type='submit']

${G_flash_msg_lct}                   //*[@id="flash"]
${G_logout_btn}                      //*[@href='/logout']
${G_web_timout}                      10s
${G_login_success_msg}               You logged into a secure area!
${G_wrongPwd_msg}                    Your password is invalid!
${G_usnNotfoud_msg}                  Your username is invalid!
${G_logout_success_msg}              You logged out of the secure area!
${G_test_result}                     ${None}



*** Keywords ***

Open Website And Login
    [Arguments]    ${usn_txt}    ${pwd_txt}
    Open Browser    ${G_weburl}    chrome
    Maximize Browser Window
    Wait Until Element Is Visible    ${G_usn_input}    timeout=${G_web_timout}
    Input Text    ${G_usn_input}    ${usn_txt}
    Input Password    ${G_pwd_input}    ${pwd_txt}
    Click Element    ${G_submit_btn}


Verify Login Page
    Wait Until Element Is Visible    ${G_flash_msg_lct}    timeout=${G_web_timout}
    ${login_flash_msg_txt}    Get Text   ${G_flash_msg_lct}
    ${chk_loginSuccess}    Run Keyword And Return Status    Should Match Regexp    ${login_flash_msg_txt}    ${G_login_success_msg}
    ${chk_wrongPwd}    Run Keyword And Return Status    Should Match Regexp    ${login_flash_msg_txt}    ${G_wrongPwd_msg}
    ${chk_wrongUsn}    Run Keyword And Return Status    Should Match Regexp    ${login_flash_msg_txt}    ${G_usnNotfoud_msg}

    # verify login page
    IF    '${chk_loginSuccess}' == 'True'
        ${G_test_result}    Set Variable    PASS
        Log To Console    Login Success. ${login_flash_msg_txt}
    ELSE IF     '${chk_wrongPwd}' == 'True'
        ${G_test_result}    Set Variable    FAIL
        Log To Console    Login Failed! : Password incorrect.
        Fail    Login Failed! : Password incorrect.
    ELSE IF     '${chk_wrongUsn}' == 'True'
        ${G_test_result}    Set Variable    FAIL
        Log To Console    Login Failed! : User Name is invalid.
        Fail    Login Failed! : User Name is invalid.
    END



Logout and Verify Logout
    Click Element    ${G_logout_btn}
    Wait Until Element Is Visible    ${G_flash_msg_lct}    timeout=${G_web_timout}
    ${logout_flash_msg_txt}    Get Text    ${G_flash_msg_lct}
    ${chk_logoutSuccess}    Run Keyword And Return Status    Should Match Regexp    ${logout_flash_msg_txt}    ${G_logout_success_msg}
    IF    '${chk_logoutSuccess}' == 'True'
        Log To Console    Logout success. : ${logout_flash_msg_txt}
    ELSE
        Log To Console    Logout Failed!
        Fail              Logout Failed!
    END



*** Test Cases ***

1:Login success
    [Documentation]    To verify that users can login successfully when input a correct username and password. 
    [Tags]    1_loginSuccess    run_allTC
    ${usn_txt}    Set Variable    tomsmith
    ${pwd_txt}    Set Variable    SuperSecretPassword!
    Open Website And Login    ${usn_txt}    ${pwd_txt}
    Verify Login Page
    Logout and Verify Logout


2: Login failed - Password incorrect
    [Documentation]    To verify that users can login unsuccessfully when they input a correct username but wrong password.
    [Tags]    2_loginFailed_pwd    run_allTC
    ${usn_txt}    Set Variable    tomsmith
    ${pwd_txt}    Set Variable    Password!
    Open Website And Login    ${usn_txt}    ${pwd_txt}
    Verify Login Page

3: Login failed - Username not found
    [Documentation]    To verify that users can login unsuccessfully when they input a username that did not exist
    [Tags]    3_loginFailed_usn    run_allTC
    ${usn_txt}    Set Variable    tomholland
    ${pwd_txt}    Set Variable    Password!
    Open Website And Login    ${usn_txt}    ${pwd_txt}
    Verify Login Page


