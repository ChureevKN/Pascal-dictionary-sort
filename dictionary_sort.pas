program dictionary_sort;
{$MODE OBJFPC}
uses CRT;

const str_am = 300; // maximum amount of strings
ch_am = 200; // maximum amount of chars in a single string

type
Tarray = array [1..str_am] of record
                num: Integer;
                str: String[ch_am];
                flag: Boolean;
                end;

var v, w, i, count_inp, count_ino, p1: Integer;
inf: Tarray; // inf - input array
ino: array [1..str_am] of String[ch_am]; // ino - output array
words, sorted: text; //input, output
empty_s, str1: String[ch_am];
c: Char;

//==============================
// Sorting procedure declaration
Procedure sort (var inp: Tarray; var p: Integer; var count: Integer); // p - first checking char position

var eq, i, max, num, j, q1: Integer; // j - array size
ins: Tarray;
empty_s1: String[ch_am];

Begin
for i:=1 to ch_am do
 empty_s1[i]:=' ';

for i:=1 to count do inp[i].flag:=true; // setting flags ''true'' so input strings are unmarked

while true do
  begin
  num:=0; max:=0; //nullify maximum char and it's string's number
  for i:=1 to count do // checking any unused strings left and setting start max (and num)
    if inp[i].flag = true then
      begin
      max:=ord(inp[i].str[p]);
      num:=i;
      end;
  if num = 0 then break; // procedure breaks when it's input array is processed

  for i:=1 to count do // find max char at defined position (p) among unused strings. ord(max char) occurs being minimal of ords.
    if (ord(inp[i].str[p]) < max) and (inp[i].flag = true) then
      begin
      max:=ord(inp[i].str[p]);
      num:=i; // it's number
      end;

  for i:=1 to count do // nullify inner array
    begin
    ins[i].num:=0; ins[i].str:=''; ins[i].flag:=false;
    end;

  j:=0; // nullify new array size counter
  for i:=1 to count do // create new array with such a strings, count them, mark used strings
    if (ord(inp[i].str[p]) = max) and (inp[i].flag = true) then
      begin
      j:=j+1;
      ins[j].str:=inp[i].str;
      inp[i].flag:=false;
      end;

  if j=1 then // add sorted string or proceed with new array
    begin
    count_ino:=count_ino+1;
    ino[count_ino]:=inp[num].str;
    end
    else
      begin
      eq:=1;
      for i:=2 to j do
        if inp[1].str = inp[i].str then
          inc(eq);

      if eq = j then
        for i:=1 to j do
          begin
          inc(count_ino);
          ino[count_ino]:=inp[num].str;
          end
        else
        begin
        q1:=p+1;
        sort (ins, q1, j);
        end;
      end;

end;

End;

//===============================
//=============================== Main
//===============================
Begin
for w:= 1 to ch_am do
  empty_s[w]:=' ';

for w:=1 to str_am do // fill input and output strings with spaces
    begin;
    inf[w].str:=empty_s;
    ino[w]:=empty_s;
    end;

clrscr;
assign(words, 'words.txt');

try
  reset(words); // attempt open input file
except  // exit
  writeLn ('Could not open ''words.txt''.');
  writeLn ('Make sure it''s in the same place with this program and try again.');
  readkey;
  exit;
end;

count_inp:=0; // nullify input array's strings counter and input string holder
for i:=1 to ch_am do
 str1[i]:=' ';

while not EOF(words) do // read strings from input file, premoderate strings, write strings to input array
  begin
  read (words, c);
  if ord(c)=13 then
    begin
    count_inp:=count_inp+1;
    inf[count_inp].str:=str1;
    str1:='';
    read (words, c);
    end
      else
      str1:=str1+c;
  end;
  count_inp:=count_inp+1; // when meets EOF, closes without writing the last string, so fix it
  inf[count_inp].str:=str1;
  for i:=1 to ch_am do
    str1[i]:=' ';

close (words); // close input file

count_ino:=0; // nullify output array strings counter
p1:=1;
sort (inf, p1, count_inp);

writeLn('count_inp = ', count_inp); writeLn('count_ino = ', count_ino);
writeLn('Sorting finished. Press to show result.'); writeLn;
readkey;

assign(sorted, 'sorted.txt');
rewrite(sorted);

for i:=1 to count_ino do
  begin
  writeLn(ino[i]);
  writeLn(sorted, ino[i]);
  end;

close(sorted);
writeLn ('===');
readkey;
End.
