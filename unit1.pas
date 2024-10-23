unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls;

type

  { TForm1 }

  TForm1 = class(TForm)
    Atap: TButton;
    Perkecil: TButton;
    Perbesar: TButton;
    UbahWarnaAtap: TButton;
    UbahWarnaDingding: TButton;
    ColorDialog1: TColorDialog;
    Panel1: TPanel; // Panel untuk menggambar
    Pemandangan: TButton;
    Jendela: TButton;
    Pintu: TButton;
    Hapus: TButton;
    Dinding: TButton;
    Kiri: TButton;
    Kanan: TButton;
    Animasi: TButton; // Tambahkan tombol untuk animasi
    Timer1: TTimer;
    procedure AtapClick(Sender: TObject);
    procedure UbahWarnaAtapClick(Sender: TObject); // Prosedur untuk mengubah warna atap
    procedure UbahWarnaDingdingClick(Sender: TObject); // Prosedur untuk mengubah warna dinding
    procedure DindingClick(Sender: TObject);
    procedure PintuClick(Sender: TObject);
    procedure JendelaClick(Sender: TObject);
    procedure PemandanganClick(Sender: TObject);
    procedure HapusClick(Sender: TObject);
    procedure KiriClick(Sender: TObject);
    procedure KananClick(Sender: TObject);
    procedure AnimasiClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure PerkecilClick(Sender: TObject); // Prosedur untuk memperkecil
    procedure PerbesarClick(Sender: TObject); // Prosedur untuk memperbesar
  private
    ShiftX: Integer; // Untuk menggeser elemen rumah
    SunY: Integer; // Posisi vertikal matahari
    SunDirection: Integer; // 1 untuk ke bawah, -1 untuk ke atas
    PemandanganDisplayed, AtapDisplayed, DindingDisplayed, PintuDisplayed, JendelaDisplayed: Boolean; // Status penggambaran
    WallColor, AtapColor: TColor; // Warna dinding dan atap
    ScaleFactor: Double; // Faktor skala untuk mengubah ukuran rumah
    procedure DrawAtap;
    procedure DrawDinding;
    procedure DrawPintu;
    procedure DrawJendela;
    procedure DrawPemandangan;
    procedure DrawSun; // Menggambar matahari terpisah
    procedure RedrawAll;  // Untuk menggambar ulang semua elemen
    procedure DrawPohon; // Menambahkan prosedur untuk menggambar pohon
  public
    constructor Create(AOwner: TComponent); override; // Constructor untuk inisialisasi
  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

constructor TForm1.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  WallColor := clWhite; // Inisialisasi warna dinding
  AtapColor := clRed;   // Inisialisasi warna atap
  ScaleFactor := 1.0;   // Inisialisasi faktor skala
end;

procedure TForm1.RedrawAll;
begin
  // Bersihkan canvas panel sebelum menggambar ulang
  Panel1.Canvas.Brush.Color := clWhite;
  Panel1.Canvas.FillRect(Panel1.ClientRect);

  // Gambar ulang semua elemen sesuai posisi terbaru
  if PemandanganDisplayed then
    DrawPemandangan;
  if AtapDisplayed then
    DrawAtap;
  if DindingDisplayed then
    DrawDinding;
  if PintuDisplayed then
    DrawPintu;
  if JendelaDisplayed then
    DrawJendela;

  DrawSun;  // Gambar matahari
end;

procedure TForm1.DrawAtap;
var
  p: array[0..2] of TPoint;
begin
  Panel1.Canvas.Pen.Color := clBlack;
  Panel1.Canvas.Brush.Color := AtapColor; // Gunakan warna atap yang disimpan
  // Menggambar segitiga (atap) dengan ukuran sesuai faktor skala
  p[0] := Point(ShiftX + (Panel1.ClientWidth div 2), 50); // Atap di tengah
  p[1] := Point(ShiftX + (Panel1.ClientWidth div 2) - Round(50 * ScaleFactor), 100);
  p[2] := Point(ShiftX + (Panel1.ClientWidth div 2) + Round(50 * ScaleFactor), 100);
  Panel1.Canvas.Polygon(p);
  AtapDisplayed := True;  // Tandai bahwa atap telah digambar
end;

procedure TForm1.DrawDinding;
begin
  Panel1.Canvas.Pen.Color := clBlack;
  Panel1.Canvas.Brush.Color := WallColor; // Gunakan warna dinding yang disimpan
  // Menggambar persegi panjang (dinding) dengan ukuran sesuai faktor skala
  Panel1.Canvas.Rectangle(ShiftX + (Panel1.ClientWidth div 2) - Round(50 * ScaleFactor), 100,
                          ShiftX + (Panel1.ClientWidth div 2) + Round(50 * ScaleFactor), 200);
  DindingDisplayed := True;  // Tandai bahwa dinding telah digambar
end;

procedure TForm1.DrawPintu;
begin
  Panel1.Canvas.Pen.Color := clBlack;
  // Warna cokelat untuk pintu
  Panel1.Canvas.Brush.Color := RGBToColor(165, 42, 42);
  // Menggambar persegi panjang (pintu) dengan ukuran sesuai faktor skala
  Panel1.Canvas.Rectangle(ShiftX + (Panel1.ClientWidth div 2) - Round(10 * ScaleFactor), 150,
                          ShiftX + (Panel1.ClientWidth div 2) + Round(10 * ScaleFactor), 200);
  PintuDisplayed := True;  // Tandai bahwa pintu telah digambar
end;

procedure TForm1.DrawJendela;
begin
  Panel1.Canvas.Pen.Color := clBlack;
  Panel1.Canvas.Brush.Color := clBlue;
  // Menggambar persegi kecil (jendela) dengan ukuran sesuai faktor skala
  Panel1.Canvas.Rectangle(ShiftX + (Panel1.ClientWidth div 2) + Round(20 * ScaleFactor), 120,
                          ShiftX + (Panel1.ClientWidth div 2) + Round(40 * ScaleFactor), 140);
  JendelaDisplayed := True;  // Tandai bahwa jendela telah digambar
end;

procedure TForm1.DrawPemandangan;
begin
  // Menggambar rumput di bagian bawah panel
  Panel1.Canvas.Brush.Color := clGreen;
  Panel1.Canvas.FillRect(0, 200, Panel1.ClientWidth, Panel1.ClientHeight);  // Rumput di bawah rumah

  DrawPohon; // Panggil prosedur untuk menggambar pohon

  PemandanganDisplayed := True;  // Tandai bahwa pemandangan telah digambar
end;

procedure TForm1.DrawPohon;
begin
  // Menggambar pohon (batang) di samping rumah dengan ukuran sesuai faktor skala
  Panel1.Canvas.Brush.Color := RGBToColor(165, 42, 42);  // Warna cokelat untuk batang pohon
  Panel1.Canvas.Rectangle(ShiftX + Round(130 * ScaleFactor), 150, ShiftX + Round(150 * ScaleFactor), 200); // Batang pohon

  // Menggambar pohon (daun)
  Panel1.Canvas.Brush.Color := clGreen;
  Panel1.Canvas.Ellipse(ShiftX + Round(110 * ScaleFactor), 100, ShiftX + Round(170 * ScaleFactor), 150); // Daun pohon
end;

procedure TForm1.DrawSun;
begin
  // Menggambar matahari di posisi yang sesuai dengan SunY, jauh dari rumah
  Panel1.Canvas.Brush.Color := clYellow;
  Panel1.Canvas.Ellipse(10 + ShiftX, SunY, 60 + ShiftX, SunY + 50);  // Matahari
end;

procedure TForm1.AtapClick(Sender: TObject);
begin
  DrawAtap;
end;

procedure TForm1.UbahWarnaAtapClick(Sender: TObject);
begin
  // Buka ColorDialog untuk memilih warna atap
  if ColorDialog1.Execute then
  begin
    AtapColor := ColorDialog1.Color; // Simpan warna yang dipilih
    RedrawAll; // Gambar ulang untuk menerapkan warna baru
  end;
end;

procedure TForm1.UbahWarnaDingdingClick(Sender: TObject);
begin
  // Buka ColorDialog untuk memilih warna
  if ColorDialog1.Execute then
  begin
    WallColor := ColorDialog1.Color; // Simpan warna yang dipilih
    RedrawAll; // Gambar ulang untuk menerapkan warna baru
  end;
end;

procedure TForm1.DindingClick(Sender: TObject);
begin
  DrawDinding;
end;

procedure TForm1.PintuClick(Sender: TObject);
begin
  DrawPintu;
end;

procedure TForm1.JendelaClick(Sender: TObject);
begin
  DrawJendela;
end;

procedure TForm1.PemandanganClick(Sender: TObject);
begin
  PemandanganDisplayed := True;
  SunY := 10;  // Posisi awal matahari
  SunDirection := 1;  // Matahari mulai bergerak ke bawah
  DrawPemandangan;
end;

procedure TForm1.HapusClick(Sender: TObject);
begin
  // Menghapus semua gambar dengan mereset status penggambaran elemen
  ShiftX := 0;  // Reset pergeseran ke posisi awal
  AtapDisplayed := False;
  DindingDisplayed := False;
  PintuDisplayed := False;
  JendelaDisplayed := False;
  PemandanganDisplayed := False;  // Reset status pemandangan

  // Bersihkan canvas panel
  Panel1.Canvas.Brush.Color := clWhite;
  Panel1.Canvas.FillRect(Panel1.ClientRect);
end;

procedure TForm1.KiriClick(Sender: TObject);
begin
  // Geser semua elemen ke kiri
  ShiftX := ShiftX - 10;
  RedrawAll;
end;

procedure TForm1.KananClick(Sender: TObject);
begin
  // Geser semua elemen ke kanan
  ShiftX := ShiftX + 10;
  RedrawAll;
end;

procedure TForm1.AnimasiClick(Sender: TObject);
begin
  // Mulai atau hentikan animasi
  Timer1.Enabled := not Timer1.Enabled;  // Toggle Timer
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
  // Menggerakkan matahari ke atas dan ke bawah
  if SunDirection = 1 then
  begin
    SunY := SunY + 5;
    if SunY >= 150 then  // Batas bawah
      SunDirection := -1;
  end
  else
  begin
    SunY := SunY - 5;
    if SunY <= 10 then  // Batas atas
      SunDirection := 1;
  end;

  // Hanya gambar ulang matahari
  RedrawAll;
end;

procedure TForm1.PerkecilClick(Sender: TObject);
begin
// Memperkecil ukuran rumah
  if ScaleFactor > 0.2 then // Menetapkan batas minimum
    ScaleFactor := ScaleFactor - 0.1;
  RedrawAll; // Gambar ulang untuk menerapkan skala baru
end;

procedure TForm1.PerbesarClick(Sender: TObject);
begin
  // Memperbesar ukuran rumah
  ScaleFactor := ScaleFactor + 0.1;
  RedrawAll; // Gambar ulang untuk menerapkan skala baru
end;

end.
