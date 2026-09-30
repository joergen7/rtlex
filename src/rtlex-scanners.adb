package body Rtlex.Scanners
is

   function Is_Eof
     (Tk : Token)
     return Boolean
   is
     (Tk.Cat = Eof_Cat);

   function Is_Error
     (Tk : Token)
     return Boolean
   is
     (Tk.Cat = Error_Cat);

   function Get_Cat
     (Tk : Token)
     return Token_Category
   is
     (Tk.Cat);

   function Get_First
     (Tk : Token)
     return Positive
   is
     (Tk.First);

   function Get_Last
     (Tk : Token)
     return Natural
   is
     (Tk.Last);

   function Length
     (Tk : Token)
     return Natural
   is
     (Tk.Last - Tk.First + 1);

   function Make_Token
     (Cat   : Token_Category;
      First : Positive := 1;
      Last  : Natural  := 0)
     return Token
   is
     (Token'(Cat   => Cat,
             First => First,
             Last  => Last));

------------------------------------------------------------

   procedure Add_Pattern
     (Sc      : in out Scanner;
      Cat     :        Token_Category;
      Pattern :        String)
   is
      Pat : constant String :=
        "^" & Pattern;
      Re : constant GNAT.Regpat.Pattern_Matcher :=
        GNAT.Regpat.Compile (Pat);
   begin
      Sc.Pattern_Map.Include (Cat, Re);
   end Add_Pattern;

   procedure Set_Input
     (Sc    : in out Scanner;
      Input : String)
   is
   begin
      Sc.Input :=
        Ada.Strings.Unbounded.To_Unbounded_String (Input);
      Sc.Idx := 1;
   end Set_Input;

   procedure Next
     (Sc : in out Scanner;
      Tk :    out Token)
   is
      Len : constant Natural :=
        Ada.Strings.Unbounded.Length (Sc.Input);
   begin

      Tk := Make_Token (Eof_Cat);

      if Sc.Idx > Len
      then
         return;
      end if;

      declare
         Search_In : constant String :=
           Ada.Strings.Unbounded.Slice (Sc.Input, Sc.Idx, Len);
         Matches : GNAT.Regpat.Match_Array (0 .. 0);
      begin

         for Cat in Token_Category
         loop
            if Sc.Pattern_Map.Contains (Cat)
            then
               GNAT.Regpat.Match (Sc.Pattern_Map (Cat), Search_In, Matches);
               declare
                  Current_Length : constant Natural :=
                    (if Matches (0) = GNAT.Regpat.No_Match
                     then 0
                     else Matches (0).Last - Matches (0).First + 1);
               begin
                  if Current_Length > Length (Tk)
                  then
                     Tk := Make_Token
                       (Cat,
                        Matches (0).First,
                        Matches (0).Last);
                  end if;
               end;
            end if;
         end loop;

         if Length (Tk) = 0
         then
            Tk := Make_Token (Error_Cat, Sc.Idx, Len);
         else
            Sc.Idx := Tk.Last + 1;
         end if;
      end;
   end Next;

   function Get_Text
     (Sc : Scanner;
      Tk : Token)
     return String
   is
     (Ada.Strings.Unbounded.Slice
       (Sc.Input,
        Tk.First,
        Tk.Last));

   function Null_Scanner
     return Scanner
   is
     (Scanner'(Input       => Ada.Strings.Unbounded.Null_Unbounded_String,
               Idx         => Positive'First,
               Pattern_Map => Maps.Empty_Map));

end Rtlex.Scanners;
