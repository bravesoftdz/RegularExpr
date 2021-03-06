unit TestRegularExpr;
{

  Delphi DUnit Test Case
  ----------------------
  This unit contains a skeleton test case class generated by the Test Case Wizard.
  Modify the generated code to correctly setup and call the methods from the unit
  being tested.

}

interface

uses
  TestFramework, System.Classes, System.SysUtils, RegularExpr;

type
  // Test methods for class RegEx

  TestRegExPlain = class(TTestCase)
  strict private
    FRegEx: RegEx;
  public
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure TestMatchPlain;
    procedure TestMatchRepeating;
    procedure TestMatchNone;
  end;

  TestRegExExtended = class(TTestCase)
  strict private
    FRegEx: RegEx;
  public
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure TestMatch;
  end;

  TestRegExMultiline = class(TTestCase)
  strict private
    FRegEx: RegEx;
  public
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure TestMatch;
    procedure TestMatchNone;
  end;

implementation

function StrToASCII(const s: string): TBytes;
begin
  result := TEncoding.ASCII.GetBytes(s);
end;

function Bytes(const b: array of Byte): TBytes;
begin
  SetLength(result, Length(b));
  Move(b[0], result[0], Length(result));
end;

{ TestRegExPlain }

procedure TestRegExPlain.SetUp;
begin
  FRegEx := RegEx.Create('b+');
end;

procedure TestRegExPlain.TearDown;
begin
  FRegEx := nil;
end;

procedure TestRegExPlain.TestMatchNone;
var
  m: RegExMatch;
begin
  m := FRegEx.Match(StrToASCII('def'));
  CheckFalse(m, 'Incorrect positive match');
end;

procedure TestRegExPlain.TestMatchPlain;
var
  m: RegExMatch;
begin
  m := FRegEx.Match(StrToASCII('abc'));
  CheckTrue(m, 'Incorrect positive match');
end;

procedure TestRegExPlain.TestMatchRepeating;
var
  m: RegExMatch;
begin
  m := FRegEx.Match(StrToASCII('abbbbbc'));
  CheckTrue(m, 'Failed to match');
  CheckEquals(1, m.Offset, 'Incorrect match offset');
  CheckEquals(5, m.Length, 'Incorrect match length');
end;

{ TestRegExExtended }

procedure TestRegExExtended.SetUp;
begin
  FRegEx := RegEx.Create('\x{F8}');
end;

procedure TestRegExExtended.TearDown;
begin
  FRegEx := nil;
end;

procedure TestRegExExtended.TestMatch;
var
  m: RegExMatch;
begin
  m := FRegEx.Match(Bytes([Ord('0'), Ord('1'), Ord('2'), $f8, Ord('3'), Ord('4'), Ord('5')]));
  CheckTrue(m, 'Failed to match');
  CheckEquals(3, m.Offset, 'Incorrect match offset');
  CheckEquals(1, m.Length, 'Incorrect match length');
end;

{ TestRegExMultiline }

procedure TestRegExMultiline.SetUp;
begin
  FRegEx := RegEx.Create('^\x{F8}', [RegExMultiLine]);
end;

procedure TestRegExMultiline.TearDown;
begin
  FRegEx := nil;
end;

procedure TestRegExMultiline.TestMatch;
var
  m: RegExMatch;
begin
  m := FRegEx.Match(Bytes([Ord('0'), 1, 13, 10, $f8, Ord('3'), Ord('4')]));
  CheckTrue(m, 'Failed to match');
  CheckEquals(4, m.Offset, 'Incorrect match offset');
  CheckEquals(1, m.Length, 'Incorrect match length');
end;

procedure TestRegExMultiline.TestMatchNone;
var
  m: RegExMatch;
begin
  m := FRegEx.Match(Bytes([Ord('0'), Ord('1'), Ord('2'), $f8, Ord('3'), Ord('4'), Ord('5')]));
  CheckFalse(m, 'Incorrect positive match');
end;

initialization
  // Register any test cases with the test runner
  RegisterTest(TestRegExPlain.Suite);
  RegisterTest(TestRegExExtended.Suite);
  RegisterTest(TestRegExMultiline.Suite);
end.
