{$R-,S-,Q-}

const
  Finp          ='Input.txt';
  Fout          ='Output.txt';

  Dirs          =6;
  Dx            :array[1..Dirs] of Integer=(-1,0,1,1,0,-1);{���ֱʻ�x����}
  Dy            :array[1..Dirs] of Integer=(0,1,1,0,-1,-1);{���ֱʻ�y����}
  Swap          :array[1..Dirs] of Integer=(3,2,1,6,5,4);{���ֱʻ���ת�����̬}

  Shapes        =7;
  Size          =4;
  MyShapes      :array[1..Shapes,1..Size] of Integer={��ƬԿ��}
                ((5,4,3,1),(5,5,4,4),(5,4,4,6),
                 (4,4,4,6),(5,4,4,6),(5,4,3,1),(5,5,6,2));
  Order         :array[1..Shapes] of Integer=(2,5,1,3,6,7,4);

  Side          =7;
  Mapst         :array[1..Side] of Integer=(1,1,1,1,2,3,4);
  Maped         :array[1..Side] of Integer=(3,4,5,6,6,6,6);

type
  TShape        =array[1..Size] of Integer;

  TShapeMap     =array[0..Size+1,0..1] of Integer;

  TMap          =array[0..Side+1,0..Side+1] of Integer;

  TSet          =set of 1..Side;

var
  Shape         :array[1..Shapes,1..Dirs*2] of TShape;
  Count         :array[1..Shapes] of Integer;

  Map           :TMap;

  Lost          :Integer;

procedure InitVars;{��ʼ�����̺�Կ��}
  var
    i,j         :Integer;
  begin
    for i:=1 to Shapes do for j:=1 to Size do Shape[i,1,j]:=MyShapes[i,j];

    FillChar(Map,Sizeof(Map),0);
    for i:=1 to Side do
      for j:=Mapst[i] to Maped[i] do
        Map[i,j]:=1
  end;

procedure ShapeToMap(x:TShape;var Map:TShapeMap);{��Կ��x��ɾ���Map,���ڳ�ʼ��ʱ����}
  var
    i,j,k,p,q   :Integer;
  begin
    FillChar(Map,Sizeof(Map),0);
    i:=0;j:=0;
    p:=i;q:=j;
    Map[1,0]:=i;Map[1,1]:=j;
    for k:=1 to Size do begin
      Inc(i,Dx[x[k]]);
      Inc(j,Dy[x[k]]);
      if i<p then p:=i;
      if j<q then q:=i;
      Map[k+1,0]:=i;
      Map[k+1,1]:=j
    end;
    Dec(p);Dec(q);
    for k:=1 to Size+1 do begin
      Dec(Map[k,0],p);
      Dec(Map[k,1],q)
    end;
    for i:=1 to Size do
      for j:=i+1 to Size+1 do
        if Longint(Map[i])<Longint(Map[j]) then begin
          Map[0]:=Map[i];Map[i]:=Map[j];Map[j]:=Map[0]
        end
  end;

function ShapeSame(x,y:TShape):Boolean;{�ж����ְڷŵ���̬�Ƿ���ͬ,���ڳ�ʼ����}
  var
    mx,my       :TShapeMap;
    i           :Integer;
  begin
    ShapeToMap(x,mx);
    ShapeToMap(y,my);
    ShapeSame:=False;
    for i:=1 to Size+1 do if Longint(mx[i])<>Longint(my[i]) then Exit;
    ShapeSame:=True
  end;

procedure Prepare;{������ƬԿ����ת����ת�����̬,��ȥ���ظ��İڷ���̬}
  var
    i,k,p,q,x   :Integer;
    Tmp         :TShape;
  begin
    for i:=1 to Shapes do begin
      Count[i]:=1;
      Tmp:=Shape[i,1];
      for p:=1 to 2 do begin
        for q:=1 to Size do Tmp[q]:=Swap[Tmp[q]];
        for x:=1 to Dirs do begin
          for q:=1 to Size do
            if Tmp[q]=Dirs then Tmp[q]:=1 else Inc(Tmp[q]);
          for q:=Count[i] downto 0 do
            if q=0 then begin
              Inc(Count[i]);
              Shape[i,Count[i]]:=Tmp
            end else if ShapeSame(Tmp,Shape[i,q]) then Break
        end
      end
    end
  end;

function Check:Boolean;{�ж��Ƿ���Լ�֦��������ⱨ��}
  var
    Tmp         :TMap;
    i,j,k       :Integer;

  procedure Count(i,j:Integer);{������ͨ����}
    var
      p :Integer;
    begin
      if Tmp[i,j]<>1 then Exit;
      Tmp[i,j]:=0;
      Inc(k);
      for p:=1 to Dirs do Count(i+Dx[p],j+Dy[p])
    end;

  begin
    Check:=False;
    Tmp:=Map;
    for i:=1 to Side do
      for j:=1 to Side do
        if Tmp[i,j]=1 then begin
          k:=0;
          Count(i,j);
          if k mod 5<>0 then Exit{���ĳ����ͨ�����ĵ�������5�ı���,����Լ�֦}
        end;
    Check:=True
  end;

function Put(i,j,k,p:Integer):Boolean;{����Կ��}
  var
    x   :Integer;
  begin
    Put:=False;
    for x:=1 to Size do begin
      if (Map[i,j]<>1) and (Map[i,j]<>-k) then Exit;
      Map[i,j]:=-k;
      Inc(i,Dx[Shape[k,p,x]]);
      Inc(j,Dy[Shape[k,p,x]])
    end;
    if (Map[i,j]<>1) and (Map[i,j]<>-k) then Exit;
    Map[i,j]:=-k;
    Put:=Check
  end;

procedure GetInfo;{��������}
  var
    i   :Integer;
  begin
    Assign(Input,Finp);Reset(Input);
    Readln(i);
    for Lost:=1 to Shapes do if Order[Lost]=i then Break;
    Close(Input)
  end;

procedure Print;{���}
  var
    i,j :Integer;
  begin
    Assign(Output,Fout);Rewrite(Output);
    for i:=1 to Side do
      for j:=1 to Side do
        if Map[i,j]<0 then Write(Order[-Map[i,j]],' ');
    Writeln;
    Close(Output)
  end;

procedure Search(Can:TSet);{����}
  var
    Old         :TMap;
    i,j,k,p     :Integer;
  begin
    if Can=[] then begin
      Print;
      Halt
    end;
    k:=0;repeat Inc(k) until k in Can;
    Old:=Map;
    for i:=1 to Side do
      for j:=1 to Side do
        if Map[i,j]=1 then
          for p:=1 to Count[k] do begin
            if Put(i,j,k,p) then begin
              Exclude(Can,k);
              Search(Can);
              Include(Can,k)
            end;
            Map:=Old
          end
  end;

begin
  InitVars;
  Prepare;
  GetInfo;
  Search([1..Shapes]-[Lost])
end.