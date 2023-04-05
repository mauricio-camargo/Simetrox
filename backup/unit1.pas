unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls,
  Buttons, BGRABitmap, BGRABitmapTypes, BGRAGraphicControl, LCLIntf,
  LCLType, IntfGraphics, SpinEx, FPImage, Math, BCTypes;

type

  { TForm1 }

  TForm1 = class(TForm)
    BGCont: TBGRAGraphicControl;
    bScaleAuto: TSpeedButton;
    bScaleM: TSpeedButton;
    bScaleP: TSpeedButton;
    Button1: TButton;
    Button3: TButton;
    Button4: TButton;
    CheckBox1: TCheckBox;
    ColorButton1: TColorButton;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    OpenDialog1: TOpenDialog;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    SpinG: TSpinEditEx;
    procedure BGContRedraw(Sender: TObject; Bitmap: TBGRABitmap);
    procedure bScaleAutoClick(Sender: TObject);
    procedure bScaleMClick(Sender: TObject);
    procedure bScalePClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure CheckBox1Change(Sender: TObject);
    procedure ColorButton1ColorChanged(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure SpinGChange(Sender: TObject);
    procedure SpinZChange(Sender: TObject);
  private
    Path:String;
    LastAngle,Zoom: ShortInt;
  public
    image: TBGRABitmap;
  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.Button1Click(Sender: TObject);
begin
  if OpenDialog1.Execute then begin
   image.Free;
   image := TBGRABitmap.Create(OpenDialog1.FileName);
   BGCont.DiscardBitmap;
  end;
end;

procedure TForm1.BGContRedraw(Sender: TObject; Bitmap: TBGRABitmap
  );
var i,x,y,x_Orig,y_Orig: integer;
imgT: TBGRABitmap;
begin
if Assigned(image) then begin
 bitmap.FillTransparent;
 imgT:=image.Resample(trunc(image.Width*Zoom/100), trunc(image.Height*Zoom/100)) as TBGRABitmap;
 bitmap.PutImageAngle(0,0, imgT, LastAngle, TResampleFilter.rfBestQuality, 0,0);
 if CheckBox1.Checked then begin
  x:=0;
  y:=0;
  x_Orig:=imgT.Width;
  y_Orig :=imgT.Height;
  //Escreve diretamente no BGCont.Canvas ao inver do image.Canvas
  BGCOnt.Bitmap.Canvas.Pen.Color:=ColorButton1.ButtonColor;;
  BGCOnt.Bitmap.Canvas.Pen.Width:=1;
  for i:=0 to x_Orig div 35 do begin
   BGCont.Bitmap.Canvas.MoveTo(x,0);
   BGCont.Bitmap.Canvas.LineTo(x,Y_Orig);
   x:=x+SpinG.Value;
  end;
  for i:=0 to y_Orig div 35 do begin
   BGCont.Bitmap.Canvas.MoveTo(0,y);
   BGCont.Bitmap.Canvas.LineTo(X_Orig,y);
   y:=y+SpinG.Value;
  end;
 end;
imgT.Free;
end;
end;

procedure TForm1.bScaleAutoClick(Sender: TObject);
begin
Zoom:=100;
BGCont.DiscardBitmap;
Label6.Caption:='100%';
end;

procedure TForm1.bScaleMClick(Sender: TObject);
begin
Zoom:=Zoom-5;
//BGCont.DiscardBitmap;
Label6.Caption:=IntToStr(Zoom)+'%';
end;

procedure TForm1.bScalePClick(Sender: TObject);
begin
Zoom:=Zoom+5;
ShowMessage(IntToStr(Zoom));
//BGCont.DiscardBitmap;
Label6.Caption:=IntToStr(Zoom)+'%';
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
LastAngle:=LastAngle+1;
BGCont.DiscardBitmap;
Label2.Caption:=IntToStr(LastAngle)+' graus';
end;

procedure TForm1.Button4Click(Sender: TObject);
begin
LastAngle:=LastAngle-1;
BGCont.DiscardBitmap;
Label2.Caption:=IntToStr(LastAngle)+' graus';
end;

procedure TForm1.CheckBox1Change(Sender: TObject);
begin
 if CheckBox1.Checked then begin
  Label1.Enabled:=True;
  Label4.Enabled:=True;
  ColorButton1.Enabled:=True;
  SpinG.Enabled:=True;
  BGCont.DiscardBitmap;
 end else begin
  Label1.Enabled:=False;
  Label4.Enabled:=False;
  ColorButton1.Enabled:=False;
  SpinG.Enabled:=False;
  BGCont.DiscardBitmap;
end;
end;

procedure TForm1.ColorButton1ColorChanged(Sender: TObject);
begin
BGCont.DiscardBitmap;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
LastAngle:=0;
Zoom:=100;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
image.Free;
end;

procedure TForm1.SpinGChange(Sender: TObject);
begin
if SpinG.Enabled then BGCont.DiscardBitmap;
end;

procedure TForm1.SpinZChange(Sender: TObject);
begin
BGCont.DiscardBitmap
end;

end.

