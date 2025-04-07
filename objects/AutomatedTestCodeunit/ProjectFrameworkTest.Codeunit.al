codeunit 50201 "Project Framework CodeUnit"
{
    Subtype = Test;

    [Test]
    procedure TestProjectFramework()
    var
        ProjectNo: Code[20];
    begin
        CreateCustomer();

        CreateProject();

        CreateProjectFramework();
    end;

    internal procedure CreateCustomer()
    begin
        Customer.Init();
        Customer."No." := 'C00060';
        CustomerNumber := Customer."No.";
        Customer.Name := 'Test Customer ML';
        CustomerName := Customer.Name;
        Customer.Address := 'Test Address ML';
        CustomerAddress := Customer.Address;
        Customer."Gen. Bus. Posting Group" := 'DOMESTIC';
        Customer."VAT Bus. Posting Group" := 'DOMESTIC';
        Customer."Customer Posting Group" := 'DOMESTIC';

        Customer.Insert(true);

        Assert.IsTrue(Customer.Get(Customer."No."), 'Customer was not found after insertion.');
        Assert.AreEqual('C00060', Customer."No.", 'Customer was not created with the correct number.');
        Assert.AreEqual('Test Customer ML', Customer.Name, 'Customer was not created with the correct name.');
        Assert.AreEqual('Test Address ML', Customer.Address, 'Customer was not created with the correct address.');
        Assert.AreEqual('DOMESTIC', Customer."Gen. Bus. Posting Group", 'Customer was not created with the correct Gen. Bus. Posting Group.');
        Assert.AreEqual('DOMESTIC', Customer."VAT Bus. Posting Group", 'Customer was not created with the correct VAT Bus. Posting Group.');
        Assert.AreEqual('DOMESTIC', Customer."Customer Posting Group", 'Customer was not created with the correct Customer Posting Group.');
    end;

    internal procedure CreateProject()
    var
        CurrentJobNo: Integer;
        JobPrefix: Text[3];
    begin
        SalesAndRecSetup.Get();
        Job.Init();

        If Job.FindLast() then begin
            JobPrefix := CopyStr(Job."No.", 1, 3); // Get the prefix from the last job number

            Evaluate(CurrentJobNo, CopyStr(Job."No.", 4, 5));
            CurrentJobNo := CurrentJobNo + 10;
        end else begin
            JobPrefix := 'J00';
            CurrentJobNo := 150;
        end;

        NewJobNo := StrSubstNo('%1%2', JobPrefix, Format(CurrentJobNo, 0, '<Integer>')); // Creates J00140, J00150, etc.
        Job."No." := NewJobNo; // Set the new job number
        Job."Project Framework Code" := '';

        Job.Description := 'Test Job ML';
        Job."Sell-to Customer No." := CustomerNumber;
        Job."Sell-to Customer Name" := CustomerName;
        Job."Sell-to Address" := CustomerAddress;

        Assert.IsTrue(Job.Insert(true), 'Job was not inserted correctly.');
        Assert.AreEqual('Test Job ML', Job.Description, 'Job was not created with the correct description.');
        Assert.AreEqual(CustomerNumber, Job."Sell-to Customer No.", 'Job was not created with the correct Sell-to Customer No.');
        Assert.AreEqual('Test Customer ML', Job."Sell-to Customer Name", 'Job was not created with the correct Sell-to Customer Name.');
        Assert.AreEqual('Test Address ML', Job."Sell-to Address", 'Job was not created with the correct Sell-to Customer Address.');
    end;

    internal procedure CreateProjectFramework()
    var
        ProjectFrameworkPrefix: Text[4];
        CurrentProjectFramework: Integer;
    begin
        Job.Get(NewJobNo);
        ProjectFramework.Init(); // Should be PF0001 

        if ProjectFramework.FindLast() then begin
            ProjectFrameworkPrefix := CopyStr(ProjectFramework.Code, 1, 4); // Get the prefix from the last project framework number PF0
            Evaluate(CurrentProjectFramework, CopyStr(ProjectFramework.Code, 5));
            CurrentProjectFramework := CurrentProjectFramework + 1;

        end else begin
            ProjectFrameworkPrefix := 'PF00';
            CurrentProjectFramework := 1;
        end;

        NewProjectFrameworkNo := StrSubstNo('%1%2', ProjectFrameworkPrefix, Format(CurrentProjectFramework, 0, '<Integer>')); // Creates J00140, J00150, etc.
        ProjectFramework.Code := NewProjectFrameworkNo; // Set the new project framework number
        Job."Project Framework Code" := NewProjectFrameworkNo; // this is where we are setting the project framework number to the job and it is become a record bridge
        Job.Modify(); // safe the record

        ProjectFramework.Name := 'Test Project Framework ML';
        CurrentUserId := UserId;
        ProjectFramework.Validate(Owner, CurrentUserId);
        ProjectFramework.validate("Customer No.", CustomerNumber);
        ProjectFramework."Internal Reference" := 'Test Internal Reference ML';
        ProjectFramework."Customer Reference" := 'Test Customer Reference ML';
        ProjectFramework.State := ProjectFramework.State::Active;
        ProjectFramework."Start Date" := Today;
        ProjectFramework."End Date" := Today + 10;
        ProjectFramework.Description := 'Test Description ML 1000 Characters';

        Assert.IsTrue(ProjectFramework.Insert(true), 'Project Framework was not inserted correctly.');

        Assert.AreEqual(NewProjectFrameworkNo, ProjectFramework.Code, 'Project Framework was not created with the correct number.');
        Assert.AreEqual('Test Project Framework ML', ProjectFramework.Name, 'Project Framework was not created with the correct name.');
        Assert.AreEqual(CurrentUserId, ProjectFramework.Owner, 'Project Framework was not created with the correct Owner.');
        Assert.AreEqual(CustomerNumber, ProjectFramework."Customer No.", 'Project Framework was not created with the correct Customer No.');
        Assert.AreEqual('Test Internal Reference ML', ProjectFramework."Internal Reference", 'Project Framework was not created with the correct Internal Reference.');
        Assert.AreEqual('Test Customer Reference ML', ProjectFramework."Customer Reference", 'Project Framework was not created with the correct Customer Reference.');
        Assert.AreNotEqual(ProjectFramework.State, ProjectFramework.State::Inactive, 'Project Framework was not created with the correct State.');
        Assert.AreEqual(Today, ProjectFramework."Start Date", 'Project Framework was not created with the correct Start Date.');
        Assert.AreEqual(Today + 10, ProjectFramework."End Date", 'Project Framework was not created with the correct End Date.');
        Assert.AreEqual('Test Description ML 1000 Characters', ProjectFramework.Description, 'Project Framework was not created with the correct Description.');
    end;

    [Test]
    procedure EmptyProjectFrameworkNo()
    var
        ExpectedErrMessage: Text;
    begin
        Job.Get(NewJobNo);
        ProjectFramework.Init();
        ProjectFramework.Code := '';

        if ProjectFramework.Code = '' then begin
            ExpectedErrMessage := 'No. must have a value in Project Framework: No.=. It cannot be zero or empty.';
            ProjectFramework.Insert(false);
        end;

        Assert.IsFalse(ProjectFramework.Insert(false), 'Project Framework was inserted with an empty No.');
    end;

    [Test]
    procedure ProjectFrameworkEndDatesValidation()
    var
        ExpectedEndDateErrorMessage: Text[100];
    begin
        ExpectedEndDateErrorMessage := StrSubstNo('End date must not be earlier than start date for Project Framework %1', NewProjectFrameworkNo);
        Job.Get(NewJobNo);
        ProjectFramework.Get(NewProjectFrameworkNo);
        ProjectFramework."Start Date" := Today;
        ProjectFramework.Modify();
        asserterror ProjectFramework.Validate("End Date", Today - 10);

        Assert.AreEqual(GetLastErrorText(), ExpectedEndDateErrorMessage, 'Invalid error message');
    end;

    [Test]
    procedure ProjectFrameworkStartDatesValidation()
    var
        ExpectedStartDateErrorMessage: Text[100];
    begin
        ExpectedStartDateErrorMessage := StrSubstNo('Start date must not be later than end date for Project Framework %1', NewProjectFrameworkNo);
        Job.Get(NewJobNo);
        ProjectFramework.Get(NewProjectFrameworkNo);
        ProjectFramework."End Date" := Today;
        ProjectFramework.Modify();
        asserterror ProjectFramework.Validate("Start Date", Today + 10);

        Assert.AreEqual(GetLastErrorText(), ExpectedStartDateErrorMessage, 'Invalid error message');
    end;

    [Test]
    procedure ChangeStatusToInactive()
    var
        ChangeStatusToInactive: Text[100];
        FirstJobNo: Code[20];
        SecondJobNo: Code[20];
        FirstProjectFrameworkNo: Code[20];
        SecondProjectFrameworkNo: Code[20];

    begin
        CreateProject();
        CreateProjectFramework();
        FirstJobNo := NewJobNo;
        FirstProjectFrameworkNo := NewProjectFrameworkNo;
        ChangeStatusToInactive := StrSubstNo('Project Framework %1 is in use and cannot be set to inactive.', FirstProjectFrameworkNo);

        CreateProject();
        CreateProjectFramework();
        SecondJobNo := NewJobNo;

        Job.Get(SecondJobNo);
        ProjectFramework.Get(FirstProjectFrameworkNo);
        Job."Project Framework Code" := FirstProjectFrameworkNo;

        asserterror ProjectFramework.Validate(State, ProjectFramework.State::Inactive);

        Assert.AreEqual(GetLastErrorText(), ChangeStatusToInactive, 'Invalid error message');

    end;



    var
        Assert: Codeunit "Library Assert";
        Job: Record Job;
        ProjectFramework: Record "Project Framework";
        SalesAndRecSetup: Record "Sales & Receivables Setup";
        CustomerNumber: Code[20];
        CustomerName: Text[100];
        CustomerAddress: Text[100];
        UserSetup: Record "User Setup";
        UserName: record User;
        Customer: Record Customer;
        CurrentUserId: Text[250];
        //ProjectFrameworkNo: Code[20];
        NewJobNo: Code[20];
        NewProjectFrameworkNo: Code[20];
}