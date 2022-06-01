codeunit 31321 "Requisition Line Handler CZL"
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::ReqJnlManagement, 'OnBeforeOpenJnl', '', false, false)]
    local procedure JournalTemplateUserRestrictionsOnBeforeOpenJnl(var ReqLine: Record "Requisition Line")
    var
        UserSetupAdvManagementCZL: Codeunit "User Setup Adv. Management CZL";
        UserSetupLineTypeCZL: Enum "User Setup Line Type CZL";
        JournalTemplateName: Code[10];
    begin
        JournalTemplateName := ReqLine.GetRangeMax("Worksheet Template Name");
        UserSetupLineTypeCZL := UserSetupLineTypeCZL::"Req. Worksheet";
        UserSetupAdvManagementCZL.CheckJournalTemplate(UserSetupLineTypeCZL, JournalTemplateName);
    end;
}