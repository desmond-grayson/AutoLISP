; ================================================================================================
; ============ Personal Preferences for workspace ================================================
; ================================================================================================


(setvar "menuBar" 0)           ; toggles menubar "Home, Insert, Annotate, etc" display
(setvar "cmdEcho" 0)           ; suppresses dialouge boxes within commandline
(setvar "acadLspAsDoc" 0)      ; controls how ACAD will load the lisp file
(setvar "layerEvalCtl" 0)      ; disables evaluation and notification of new layers
(setvar "ltScale" 0.375)       ; sets line type scale
(setvar "ceLtScale" 1)         ; sets object lintype scaling factor
(setvar "msLtScale" 1)         ; model space linetypes scaled by annotation type
(setvar "defaultGizmo" 3)      ; disables gizmo when object selected in 3d visual mode
(setvar "refPathType" 2)       ; full file path names by default
(setvar "dimAdec" 0)           ; disables decimils when displaying angluar dimensions (independant of dimdec)
(setvar "pdMode" 3)            ; controls how point objects are displayed 
(setvar "constraIntInfer" 0)   ; this causes unintended line stickage if enabled
(setvar "gridMode" 0)          ; disables background grid
(setvar "angDir" 1)            ; clockwise rotational values
(setvar "dimFrac" 2)           ; controls dimension fractional layout
(setvar "dimZin" 12)           ; controls dimension zero suppression
(setvar "rememberFolders" 1)   ; consisitent filepath based on the directory where AutoCAD launched
(setvar "selectionCycling" 0)  ; disables selection dialouge box 
(setvar "dimClrE" 1)           ; dimension extension color, red
(setvar "dimClrT" 0)           ; dimension text color, by block
(setvar "dimClrD" 1)           ; dimension arrow color, red
(setvar "wipeoutFrame" 2)      ; wipeout frame does not appear once plotted.
(setvar "dimAzin" 2)           ; supresses trailing zeroes for decimal angular dimensions
(setvar "gripColor" 5)         ; set color of grips @ unselected
(setvar "gripHover" 255)       ; set color of grips @ hover
(setvar "gripHot" 255)         ; set color of grips @ selection
(setvar "layoutRegenCtl" 2)    ; supresses layout regeneration after first page load, reads from cache after
(setvar "mirrText" 0)          ; retains text orientation through mirroring
(setvar "pickFirst" 1)         ; allows selection before running commands
(setvar "dynMode" 3)
(setvar "lispInit" 0)          ; preservers AutoLISP variables & functions between drawings
(setvar "fileTabPreview" 0)    ; disables dwg preview on tab hover
(setvar "fileTabThumbHover" 0) ; disables preloading of drawings on tab mouse hove


; ================================================================================================
; ============ Globals ===========================================================================
; ================================================================================================


(setq usecommandline 1)

(setq typBaseDepth    24 
      typTallDepth    25.25 
      typUpperDepth   14
      typCTDepth      25.25
      typSplashHeight  4
      typValanceHeight 3)

(setq leaderUp 0.3732 leaderDown -0.345)

(setq togglableLayers (list "2d_item" "2d_text" "3d_item" "3d_product" "2d_dim" "2d_hatch" "2d_division" "2D_Solid_Surface" "2d_dimk"))


; ================================================================================================
; ============ Layer Creation ====================================================================
; ================================================================================================


(defun layerCreation (lyrName color lineType lineWeight)
	(command-s "-layer" "make"             lyrName "")
	(command-s "-layer" "color" color      lyrName "")
	(command-s "-layer" "ltype" lineType   lyrName "")
	(command-s "-layer" "lw"    lineWeight lyrName ""))

; Ensure these layers exist within all documents opened
(command "-layer" "m" "lines" "c" "230" "lines" "lt" "continuous" "" "")          ; 111 Lines Layer
(command "-layer" "m" "deets" "c" "2" "deets" "lt" "continuous" "" "")            ; 222 Deets Layer
(command "-layer" "m" "green" "c" "3" "green" "lt" "continuous" "" "")            ; 333 Green Layer
(command "-layer" "m" "tops" "c" "4" "tops" "lt" "continuous" "" "")              ; 444 Tops Layer
(command "-layer" "m" "wall" "c" "150" "wall" "lt" "continuous" "" "")            ; 555 Wall Layer
(command "-layer" "m" "splash" "c" "30" "splash" "lt" "continuous" "" "")         ; 666 Special Layer
(command "-layer" "m" "cases" "c" "7" "cases" "lt" "continuous" "" "")            ; 777 Cases Layer
(command "-layer" "m" "hidden" "c" "8" "hidden" "lt" "hidden" "" "")              ; 888 Hidden Layer
(command "-layer" "m" "phantom" "c" "230" "phantom" "lt" "phantom2" "phantom" "") ; 999 Phantom Layer
(command "-layer" "m" "defpoints" "c" "7" "defpoints" "lt" "continuous" "" "")    ; ``` Defpoints Layer
(command "-layer" "m" "glass" "c" "111" "glass" "lt" "continuous" "" "")          ; ggg Glass Layer
(command "-layer" "m" "dim" "c" "3" "dim" "lt" "continuous" "" "")                ; ddd Dim Layer
(command "-layer" "m" "hatch" "c" "11" "hatch" "lt" "continuous" "" "")           ; hhh Hatch Layer
(command "-layer" "m" "defdrawing" "c" "10" "defdrawing" "lt" "continuous" "" "") ; my xline hatches


; ================================================================================================
; ============ General Commands && Utilities =====================================================
; ================================================================================================


(defun c:iwpTemplatePage () ; modify paperspace to Spencer's template
	(command-s "-pageSetup" "DWG to PDF.pc3"             ; printer name
		   "ANSI full bleed A (8.50 x 11.00 Inches)" ; paper size
		   "Inches"                                  ; paper units
		   "Landscape"                               ; drawing orientation
		   "No"                                      ; plot upside down
		   "Extents"                                 ; plot area
		   "1:1"                                     ; plot scale
		   "Center"                                  ; plot offset
		   "Yes"                                     ; apply plot styles
		   "IWP 2024.ctb"                            ; plot style table name
		   "Yes"                                     ; Plot w/ lineweights
		   "No"                                      ; Scale lineweights
		   "No"                                      ; Plot paperspace first
		   "No"))                                    ; Hide paperspace objects

(defun c:fr23 () ; freeze togglable layers
	(foreach layerName togglableLayers (command-s "-layer" "freeze" layerName "")))

(defun c:th23 () ; thaw togglable layers
	(foreach layerName togglableLayers (command-s "-layer" "thaw" layerName "")))

(c:fr23) ; autorun freeze layers

(defun c:sysvariables () ; View & edit system variables.
	(command-s "sysvdlg"))

(defun getScaleOffset ()
	(setq scf (getvar 'dimscale))
	(setq ext (getvar 'dimexe))
	(setq dimoffset (* scf ext 2)))

(defun c:dpan () ; override making pan loop indefinetly
	(while t;rue
		(command "-pan" pause pause)))

(defun c:wt () ; one hand shortcut for wipeout
	(command-s "wipeout"))

(defun formatDimsForLeader (dim) ; format dimensions to be used in leaders
	(rtos dim 5 4))

(defun LM:open ( target / rtn shl ) ; Utility written by Lee Mac, launches an external File Browser window at the specified target
	;; target - [int/str] File, folder or ShellSpecialFolderConstants enum
	(if (and (or (= 'int (type target)) (setq target (findfile target)))
		(setq shl (vla-getinterfaceobject (vlax-get-acad-object) "shell.application")))
		(progn
			(setq rtn (vl-catch-all-apply 'vlax-invoke (list shl 'open target)))
	        (vlax-release-object shl)
	        (if (vl-catch-all-error-p rtn)
				(prompt (vl-catch-all-error-message rtn))
				t))))

(defun c:gobl () ; open block library in file explorer
	(LM:open "L:\\Templates\\AutoCad\\Block-Lib"))

(defun c:gosink () ; open personal plumbing blocks in file explorer
	(LM:open "L:\\Templates\\AutoCad\\Block-Lib\\Plumbing\\Sink\\des_sink"))

(defun c:gopl () ; open hardware pics folder
	(LM:open "L:\\Templates\\AutoCad\\Hardware\\Pics"))

(defun c:goof () ; open order files in file explorer
	(LM:open "L:\\Orders"))

(defun c:gowz () ; Open Desmond's room name utility
	(LM:open "L:\\Shared\\Desmond\\elevation_wizard.exe"))

(defun c:godoc () ; Open Desmond's engineer docs utility
	(display-msg "\nA wizard arrives when they intend, please be patient.\n" 0)
	(LM:open "L:\\Shared\\Desmond\\desmonds_template_utility.exe"))

(defun c:INeedAVacation () ; Vacation request or notice of absence, you decide.
	(LM:open "L:\\Templates\\Office\\Vacation Form Employee Template.xls"))

(defun display-msg (msg mode / )
	(if (= mode 0)
		(prompt (strcat "\n" msg))
		(alert msg))
	(princ))

(defun UserSelect (qty / ) ; prompt for user selection or pass premade selection as value
	(setq usersel (if (ssget "_I")
		(ssget "_I")
		(if (= qty 1)
			(ssget "_:S+.")
			(ssget "_:E")))))

(defun c:sac ( / samObj filLst) ; select all color (layer)
	(if (setq samObj (entsel "\nSelect object at desired layer > "))
	(progn
		(setq filLst (assoc 8 (entget (car samObj))))
		(sssetfirst nil (ssget "_X" (list filLst))))))

(defun mirrorFunction (del) ; expects "_y" or "_n" as arguement
	(setq ss (UserSelect))
	(vl-cmdf "._mirror" ss "" pause pause del))

(defun c:miry () ; mirror w/ auto delete enabled
	(mirrorFunction "_y"))

(defun c:mirn () ; mirror w/ auto delete disabled
	(mirrorFunction "_n"))

(defun c:d () ; dimension ortholinear
	(command-s "-layer" "set" "dim" "")
	(command "dimlinear" pause pause pause)
	(command-s "dimbreak" "last" ""))

(defun c:dc () ; dimension continue
	(command-s "-layer" "set" "dim" "")
	(while t;rue	
		(command "dimcontinue" pause "" "")
		(command-s "dimbreak" "last" "")))

(defun c:da () ; dimension aligned
	(command-s "-layer" "set" "dim" "")
	(command "dimaligned" pause pause pause)
	(command-s "dimbreak" "last" "")
	(command "dimedit" "oblique" "last" "" pause))

(defun c:daa () ; dimension oblique edit
	(setq sel (UserSelect 1))
	(command "dimedit" "oblique" sel "" pause))

(defun c:dbb () ; dimension break
  (setq sel (UserSelect "many"))
  (UserCancel)
  (command "dimbreak" sel ""))

;(defun c:d () ; testing implement of dimensioning tool, allows for 
;	(setq p1 (getpoint "p1") p2 (getpoint "p2") p3 (getpoint "p3"))
;	(setq userUnits (getreal "Units to offet"))
;	(command-s "-layer" "set" "dim" "")
;	(setq dimOffset (* (getvar "dimscale") (getvar "dimexe") 2))
;	(setq pointDiff (list 
;		(- (car p3) (car p2))
;		(- (cadr p3) (cadr p2))
;		0))
;	(if (> (abs (car pointDiff)) (abs (cadr pointDiff)))
;		(progn
;			(setq direction "vertical")
;			(if (minusp (car pointDiff))
;				(setq isLeft -1)
;				(setq isLeft  1))
;			(setq dimOut (list 
;				(+ (car p2) (* userUnits dimOffset isLeft))
;				(cadr p2)
;				0)))
;		(progn
;			(setq direction "horizontal")	
;			(if (minusp (cadr pointDiff))
;				(setq isAbove -1)
;				(setq isAbove  1))
;			(setq dimOut (list
;				(car p2)
;				(+ (cadr p2) (* userUnits dimOffset isAbove))
;				0))))
;	(command-s "dimlinear" p1 p2 "properties" direction dimOut))

(defun c:drad () ; custom dimradius
	(command-s "-layer" "set" "dim" "")
	(command "dimradius" pause))
	
(defun c:darc () ; custom dimangular
	(command-s "-layer" "set" "dim" "")
	(command "dimangular" pause))
	
(defun c:dv () ; divide, one handed shortcut. note - overwrites builtin dv(iew) shortcut
	(setq usersel (UserSelect 1))
	(command "divide" usersel pause))

(defun c:caa () ; references express tool command
	(c:closeallother))

(defun c:sas () ; references express tool command
	(c:saveall))

(defun c:eng () ; Sets dims to decimal output plus metric
	;(setq usersel (UserSelect 0))
	(command-s "dimlunit" 2) ; sets decimal notation
	(command-s "dimdec" 4) ; precision level of dims
	(command-s "dimtih" 0) ; dim text alignment (aligned)
	(command-s "dimalt" 0)) ; enable dim alt text
	;(command "dim" "update" usersel)

(defun c:drft () ; Sets dims to fractional output
	;(setq usersel (UserSelect 0)) ; TODO: REWORK THIS TO RUN COMMANDS FIRST & IF THERE IS USER SELECTION, ALSO UPDATE IT.
	(command-s "dimlunit" 5)
	(command-s "dimdec" 6)
	(command-s "dimtih" 1)
	(command-s "dimalt" 0))

(defun c:f` () ; remove arc from lines
	(setvar "filletrad" 0)
	(command-s "fillet"))

(defun c:f`1 () ; fillet 0.0625" rad
	(setvar "filletrad" 0.0625)
	(command-s "fillet"))

(defun c:f125 () ; fillet 0.125" rad
	(setvar "filletrad" 0.125)
	(command-s "fillet"))

(defun c:f25 () ; fillet 0.25" rad
	(setvar "filletrad" 0.25)
	(command-s "fillet"))

(defun c:f5 () ; fillet 0.5" rad
	(setvar "filletrad" 0.5)
	(command-s "fillet"))

(defun c:f75 () ; fillet 0.75" rad
	(setvar "filletrad" 0.75)
	(command-s "fillet"))

(defun c:f1 () ; fillet 1" rad
	(setvar "filletrad" 1)
	(command-s "fillet"))

(defun c:f15 () ; fillet 1.5" rad
	(setvar "filletrad" 1.5)
	(command-s "fillet"))

(defun c:f2 () ; fillet 2" rad
	(setvar "filletrad" 2)
	(command-s "fillet"))

(defun c:rcl () ; rename current layout
	(command "layout" "rename" "" pause))

(defun c:cpt () ; copy current layout tab
	(command-s "layout" "_c" "" ""))

(defun c:cptt () ; rename & move to new tab
	(setq title (getstring "Enter new tab's name: "))
	(command-s "layout" "copy" "" title)
	(command-s "layout" "set" title))

(defun c:ctd () ; delete current layout
	(command-s "layout" "_d" ""))

(defun c:drwf () ; bring to front
	(command-s "draworder" "front"))

(defun c:drwb () ; bring to back
	(command-s "draworder" "back"))

(defun c:drwa () ; bring above
	(command-s "draworder" "above"))

(defun c:drwu () ; bring under
	(command-s "draworder" "under"))

(defun c:2dwa () ; toggle 2D walls frozen & thawed status
  (if (= 0 (cdr (assoc 70 (tblsearch "layer" "2d_Wall"))))
	(command-s "-layer" "freeze" "2d_Wall" "")
	(command-s "-layer" "thaw" "2d_Wall" "")))

(defun c:deseqq () ; apply personal settings to drafting drawing
	(c:fr23)
	(command-s "wipeoutframe" 2)
	(c:sty3-8)
	(c:desdrafttemplate))

(defun c:desegg () ; apply personal settings to new drawing
	(c:fr23)
	(command-s "wipeoutframe" 2)
	(c:sty1-2)
	(c:destemplate)
	(c:xx))

(defun c:destemplate () ; my engineering template
	(command-s "layout" "_t" "template_engineering.dwt" "000" ""))

(defun c:desdrafttemplate () ; personal drafting template
	(command-s "layout" "_t" "template_drafting.dwt" "x_x_x" ""))

(defun c:bmask (/ ss1 num cnt obj ent) ; background mask text
	(setq ss1 (ssget '((0 . "MULTILEADER,MTEXT")))
		num (sslength ss1)
		cnt 0)
	(repeat num
	(setq obj (vlax-ename->vla-object (ssname ss1 cnt)))
	(setq nam (vlax-get-property obj 'objectname))
	(if(= nam "AcDbMText")
		(progn
			(if(= (vlax-get-property obj 'BackgroundFill):vlax-false)	(progn(vlax-put-property obj 'BackgroundFill :vlax-true)))))
	(if(= nam "AcDbMLeader")
		(progn
		  (if(= (vlax-get-property obj 'TextBackgroundFill):VLAX-FALSE)
			(progn
			(vlax-put-property obj 'TextBackgroundFill "-1")))))
	(setq cnt (1+ cnt))); repeat
	(vl-cmdf "_draworder" ss1 "" "f")
		(princ))

(defun c:dimbmask (/ CNT ENT ENTDATA NEWENTDATA NUM SS1) ; backfill dimensions
	(vl-load-com)
	(setq	ss1 (ssget '((0 . "Dimension")))
	num (sslength ss1)
	cnt 0)
	(repeat num
		(setq ent (entget (ssname ss1 cnt)))
		(setq entdata '((-3 ("ACAD" (1000 . "DSTYLE") (1002 . "{") (1070 . 69) (1070 . 1) (1002 . "}")))))
		(setq newentdata (append ent entdata))
		(entmod newentdata)
		(setq cnt (1+ cnt)))
	(vl-cmdf "_draworder" ss1 "" "f"))

(defun c:dbf () ; toggle default backfill / mask of dimensions
	(command-s "dimtfill" (abs (- (getvar "dimtfill") 1))))

(defun c:zoomout () ; zoom out to full view
	(command-s "zoom" "a"))

(defun c:snapreset () ; snap reset my preferences
	(command-s "osmode" 14847))

(defun c:snapmid () ; snap only to midpoints
	(command-s "osmode" 2))

(defun c:snapcircle () ; snap only to center of circle
	(command-s "osmode" 4))

(defun c:sm () ; set to current dimstyle by picking an object on desired dimstyle.
	(prompt "\select desired dimstyle...")
	(command-s "-dimstyle" "_r" "")
	(princ))

(defun c:byobomb () ; optimize drawing data
	(command-s "-purge" "blocks" "*" "n") ; purge all blocks within drawing
	(command-s "-audit" "y")
	(princ))

(defun c:tc () ; convert to uppercase
	(c:-tcase)) ; TODO: don't know if there's a way to autosend upper command to this

(defun c:aqq () ; appload onehanded shortcut
	(command-s "appload"))

(defun c:+9 () ; draw infinite line vertical phantom layer
	(command-s "-layer" "set" "d4c46345L3" "")
	(command "xline" "v" pause))

(defun c:-9 () ; draw infinite line horizontal phantom layer
	(command-s "-layer" "set" "d4c46345L3" "")
	(command "xline" "h" pause))

(defun c:cxz () ; one handed shortcut for enabling commandline
	(command-s "commandline"))

(defun c:woff () ; offset used for wall default thickness
	(command-s "offset" 5))

(defun c:ucsreset () ; resets ucs to default
	(command-s "ucs" "w"))

(defun c:ccc () ; one hand shortcut for closing current tab
	(command-s "close"))

(defun UserCancel () ; utility meant to cancel out of partial lisp functions
	(command)
	(command))

; ================================================================================================
; ============ Hatching ==========================================================================
; ================================================================================================


(defun defaultHatch () ; reset hatching to defaults IWP standards expect to use.
	(command-s "-layer" "set" "hatch" "")
	(setvar "hpname" "line")
	(command-s "-hatch" "transparency" 0 "")
	(command-s "-hatch" "advanced" "island" "yes" "" "")
	(setvar "hpassoc" 1)
	(command-s "-hatch" "color" "." "." ""))

(defun vrHatching (insertPoint)
	(defaultHatch)
	(setq hatchScale (* 0.5 (getvar "dimscale")))
	(command-s "-hatch" "properties" "line" hatchScale 135 "layer" "hatch" insertPoint ""))
	
(defun c:ct0 () ; hatch walls
	(defaultHatch)
	(command "-hatch" "properties" "line" 12 45 "layer" "wall" pause ""))

(defun c:ctz () ; hatch VR boxes
	(vrHatching (getpoint "Insert point")))

(defun c:pl0 () ; hatch plywood horizontal
	(defaultHatch)
	(command "-hatch" "properties" "cork" 2 0 "layer" "cases" pause ""))

(defun c:pl9 () ; hatch plywood vertical
	(defaultHatch)
	(command "-hatch" "properties" "cork" 2 90 "layer" "cases" pause ""))

(defun c:tb0 () ; hatch tackboard
	(defaultHatch)
	(command "-hatch" "properties" "ar-sand" 2.5 0 "layer" "wall" pause ""))

(defun c:wdz () ; wood grain hatch
	(defaultHatch)
	(setq hatchScale (* 0.5 (getvar "dimscale")))
	(command "-hatch" "properties" "htwood24" hatchScale 0 "layer" "splash" pause ""))

(defun c:ss0 () ; hatch solid surface stone
	(defaultHatch)
	(command "-hatch" "properties" "ar-conc" 0.125 0 "layer" "tops" pause ""))

(defun c:hl0 () ; yellow highlight hatching
	(command-s "-layer" "set" "hatch" "")
	(command-s "-hatch" "properties" "solid" "")
	(command-s "-hatch" "transparency" 90 "")
	(command-s "-hatch" "draw" "back" "")
	(command-s "-hatch" "advanced" "style" "ignore" "" "")
	(command-s "-hatch" "advanced" "associativity" "yes" "" "")
	(command-s "-hatch" "color" 51 "")
	(command "-hatch" pause "")
	(command-s "draworder" "last" "" "back")
	(defaultHatch))


; ================================================================================================
; ============ Blocks ============================================================================
; ================================================================================================



(defun c:standardsection () ; dynamic block kv82 standard
	(command-s "-layer" "set" "deets" "")
	(command "-insert" "des_stndbrkt_kv82standardSection.dwg" "explode" "yes" pause "" "" ""))

(defun c:bracketsection () ; dynamic block kv182 bracket
	(command-s "-layer" "set" "deets" "")
	(command "-insert" "des_stndbrkt_kv182bracketSection.dwg" "explode" "yes" pause "" "" ""))

(defun c:adat () ; ada cross section template
	(command "-insert" "des_adaTemplate.dwg" "explode" "yes" pause "" "" ""))

(defun c:caster () ; caster scalable section elev view
	(command-s "-layer" "set" "deets" "")
	(command "-insert" "des_caster.dwg" "explode" "yes" pause "" "" ""))

(defun c:toiletsection () ; block toilet section view dynamic
	(command-s "-layer" "set" "deets" "")
	(command "-insert" "des_toiletSectionView.dwg" "explode" "yes" pause "" "" ""))

(defun c:printer () ; block washer elevation view dynamic
	(setq ds (getvar "dimscale"))
	(command-s "-layer" "set" "deets" "")
	(command "-insert" "des_printerCopyDynamic.dwg" "explode" "yes" pause ds ds "")
	(command "-insert" "des_printerCopyDynamicCallout.dwg" "explode" "yes" pause ds ds ""))

(defun c:washer () ; block washer elevation view dynamic
	(setq ds (getvar "dimscale"))
	(command-s "-layer" "set" "deets" "")
	(command "-insert" "des_washer.dwg" "explode" "yes" pause "" "" "")
	(command "-insert" "des_washerCallout.dwg" "explode" "yes" pause ds ds ""))

(defun c:dryer () ; block washer elevation view dynamic
	(command-s "-layer" "set" "deets" "")
	(command "-insert" "des_dryer.dwg" "explode" "yes" pause "" "" "")
	(command "-insert" "des_dryerCallout.dwg" "explode" "yes" pause ds ds ""))

(defun c:arrs () ; arrow block straight
	(command "-insert" "des_arrowStraight.dwg" "explode" "yes" pause ds ds pause))

(defun c:arrc () ; arrow block curved
	(command "-insert" "des_arrowCurved.dwg" "explode" "yes" pause ds ds pause)) 

(defun c:ccref () ; elev view undercounter refrigerator 
	(command-s "-layer" "set" "deets" "")
	(command "-insert" "des_ucrefrigeratordynamic.dwg" "explode" "yes" pause "" "" "")
	(command "-insert" "des_ucrefrcallout.dwg" "explode" "yes" pause ds ds pause))

(defun c:ctp () ; plines standard laminate countertop section view w/ 4" splash
	(command-s "-layer" "set" "tops" "")
	(command "-insert" "ct_plam_plam.dwg" "explode" "yes" pause "" "" "")
	(command "rectang" pause pause)
	(command "offset" pause (ssget "_L") pause ""))

(defun c:cts () ; plines standard ss countertop w/ 4" splash & 0.25" rad
	(command-s "-layer" "set" "tops" "")
	(command "-insert" "ct_ss_125_025.dwg" "explode" "yes" pause "" "" "")
	(command "rectang" pause pause)
	(command "offset" pause (ssget "_L") pause ""))

(defun c:ctq2 () ; plines standard 2cm qtz ct w/ 4" splash; 1.5" thick
	(command-s "-layer" "set" "tops" "")
	(command "-insert" "ct_qtz_2cm_15.dwg" "explode" "yes" pause "" "" "")
	(command "rectang" pause pause)
	(command "offset" pause (ssget "_L") pause ""))

(defun c:ctq3 () ; plines standard 2cm qtz ct w/ 4" splash; 1.5" thick
	(command-s "-layer" "set" "tops" "")
	(command "-insert" "ct_qtz_3cm_125.dwg" "explode" "yes" pause "" "" "")
	(command "rectang" pause pause)
	(command "offset" pause (ssget "_L") pause ""))

(defun c:refre () ; elev view refrigerator 
	(command-s "-layer" "set" "deets" "")
	(command "-insert" "des_fridgeelev.dwg" "explode" "yes" pause "" "" "")
	(command "-insert" "des_fridgecallout.dwg" "explode" "yes" pause ds ds ""))

(defun c:refpl () ; plan view refrigerator 
	(command-s "-layer" "set" "deets" "")
	(command "-insert" "des_refrdynplanview.dwg" "explode" "yes" pause "" "" pause)
	(command "-insert" "des_fridgecallout.dwg" "explode" "yes" pause ds ds ""))

(defun c:dwe () ; elev view dishwasher 
	(command-s "-layer" "set" "deets" "")
	(command "-insert" "des_dishwasherelevation.dwg" "explode" "yes" pause "" "" "")
	(command "-insert" "des_dishwashercallout.dwg" "explode" "yes" pause ds ds ""))

(defun c:wve () ; elev view microwave
	(command-s "-layer" "set" "deets" "")
	(command "-insert" "des_microwaveelev.dwg" "explode" "yes" pause "" "" "")
	(command "-insert" "des_microwavecallout.dwg" "explode" "yes" pause ds ds ""))

(defun c:toiletplan () ; dynamic block toilet
	(command-s "-layer" "set" "wall" "")
	(command "-insert" "des_planToiletCLR.dwg" "explode" "yes" pause "" "" pause)
	(command-s "-layer" "set" "dim" "")
	(command "qleader" "near" pause pause "" "ADA CLR" ""))

(defun c:toiletelev () ; dynamic block toilet
	(command-s "-layer" "set" "wall" "")
	(command "-insert" "des_dyntoiletelev.dwg" "explode" "yes" pause "" "" 0))

(defun c:xx () ; cross off
	(while t;rue
		(command "-insert" "xx" pause pause "" 0)))

(defun c:brkt () ; block elevation view brackets
	(command-s "-layer" "set" "deets" "")
	(command "-insert" "des_brktElev.dwg" "explode" "yes" pause "" "" "")
	(command-s "-layer" "set" "dim" "")
	(command "qleader" "near" pause pause "" "IN-WALL" "BRACKET TYP" ""))

(defun c:brktinv () ; block elevation view invisible bracket
	(command-s "-layer" "set" "deets" "")
	(command "-insert" "des_invBrktElev.dwg" "explode" "yes" pause "" "" ""))

(defun c:brktt () ; block plan view bracket
	(command-s "-layer" "set" "deets" "")
	(command "-insert" "des_brktPlanview.dwg" "explode" "yes" pause "" "" pause)
	(command "move" "last" "" pause pause))

(defun c:brkttinv () ; block plan view bracket
	(command-s "-layer" "set" "deets" "")
	(command "-insert" "des_invBrktPlan.dwg" "explode" "yes" pause "" "" pause))

(defun c:brktl () ; block section view bracket
	(command-s "-layer" "set" "deets" "")
	(command "-insert" "des_brktSectionLeft.dwg" "explode" "yes" pause "" "" 0))

(defun c:brktlinv () ; block section view bracket
	(command-s "-layer" "set" "deets" "")
	(command "-insert" "des_invBrktSection.dwg" "explode" "yes" pause "" "" 0))

(defun c:cv1 () ; block ceiling height callout aff
	(setq ds (getvar "dimscale"))
	(command-s "attdia" "1")
	(command-s "-layer" "set" "dim" "")
	(command "-insert" "elev_vif" pause ds ds 0))

(defun c:graindes () ; block grain bug
	(setq cl (getvar "clayer") ds (getvar "dimscale"))
	(command-s "-layer" "set" "dim" "")
	(command "-insert" "grain_bug.dwg" pause ds ds pause)
	(command-s "-layer" "set" cl ""))

(defun c:fe () ; text insert finished end fe
	(setq cl (getvar "clayer") ds (getvar "dimscale"))
	(command-s "-layer" "set" "dim" "")
	(command "-insert" "fe.dwg" "explode" "yes" pause ds ds 0))

(defun c:plu () ; block plumbing
	(command-s "-layer" "set" "deets" "")
	(command "-insert" "des_dynamicPLU.dwg" "explode" "yes" pause "" "" pause)
	(command "move" "last" "" pause pause))

(defun c:wmi () ; block text white melamine
	(setq cl (getvar "clayer") ds (getvar "dimscale"))
	(command-s "-layer" "set" "dim" "")
	(command "-insert" "wmi.dwg" "explode" "yes" pause ds ds 0)
	(command "-layer" "set" cl ""))

(defun c:bmi () ; block text black melamine
	(setq cl (getvar "clayer") ds (getvar "dimscale"))
	(command-s "-layer" "set" "dim" "")
	(command "-insert" "bmi.dwg" "explode" "yes" pause ds ds 0)
	(command-s "-layer" "set" cl ""))

(defun c:2rl () ; block radius left countertop
	(command "-insert" "2rl.dwg" "end" pause 1 "" "" pause))

(defun c:2rr () ; block radius right countertop
	(command "-insert" "2rr.dwg" "end" pause 1 "" "" pause))

(defun c:1rl () ; block radius left countertop
	(command "-insert" "1rl.dwg" "end" pause 1 "" "" pause))

(defun c:1rr () ; block radius right countertop
	(command "-insert" "1rr.dwg" "end" pause 1 "" "" pause))

(defun c:acs () ; block textbox available clear space
	(setq ds (getvar "dimscale"))
	(command-s "-layer" "set" "dim" "")
	(command "-insert" "acs.dwg" "explode" "yes" pause ds ds 0))

(defun c:drain () ; block drain pipe section view
	(command-s "-layer" "set" "deets" "")
	(command "-insert" "sink_drain.dwg" "explode" "yes" pause "" "" 0))

(defun c:trash () ; block trash can elevation section
	(command-s "-layer" "set" "deets" "")
	(command "-insert" "trash_dynamic.dwg" "explode" "yes" pause "" "" 0))

(defun c:pps() ; Please provide sink model bug
	(setq ds (getvar "dimscale"))
	(command "-insert" "pps.dwg" "explode" "yes" pause ds ds 0))

(defun c:e1 () ; Elevation / Plan / Section bug label
	(setq ds (getvar "dimscale"))
	(command-s "attdia" "1")
	(command-s "-layer" "set" "deets" "")
	(command "-insert" "elev1.dwg" pause ds ds 0))

(defun c:vr () ; callout box
	(setq ds (getvar "dimscale"))
	(command-s "-layer" "set" "dim" "")
	(command "-insert" "vrboxcentered" "explode" "yes" pause ds ds 0))

(defun c:eqp () ; callout equipment
	(setq p1 (getpoint "Insert point") ds (getvar "dimscale") hatchInsertPoint (list
		(+ (car  p1) (* ds 0.7848))
		(- (cadr p1) (* ds 0.0938))
		0))
	(command-s "-layer" "set" "dim" "")
	(command-s "-insert" "eqp_list.dwg" "explode" "yes" p1 ds ds 0)
	(vrHatching hatchInsertPoint))

(defun c:ppl () ; callout please provide plastic laminate plam
	(setq ds (getvar "dimscale"))
	(command-s "-layer" "set" "dim" "")
	(command "-insert" "plamnote.dwg" "explode" "yes" pause ds ds 0))

(defun c:opn () ; bug for open openings
	(setq ds (getvar "dimscale"))
	(command-s "-layer" "set" "dim" "")
	(command "-insert" "opn_bug_des.dwg" "explode" "yes" pause ds ds 0))

(defun c:glass () ; Add glass-glare decroative bug
	(command "-insert" "des_glass bug.dwg" "explode" "yes" pause ds ds ""))

(defun c:earr () ; block elevation arrow 
	(command-s "attdia" "0")
	(setq ds (getvar "dimscale"))
	(command-s "-layer" "set" "dim" "")
	(command "-insert" "elev_arrow_des.dwg" "explode" "yes" pause ds ds 0))

(defun c:numboxd () ; block product number box
	(command-s "attdia" "0")
	(setq ds (getvar "dimscale"))
	(command-s "-layer" "set" "dim" "")
	(command "-insert" "product_numbox_des.dwg" "explode" "yes" pause ds ds 0))

(defun c:rguide () ; block routing guide for 2d part editting
	(command-s "attdia" "0")
	(command-s "-layer" "set" "green" "")
	(command "-insert" "desmond_route_in_out_guide.dwg" "explode" "yes" pause "" "" 0))

(defun c:hingedes () ; block section view hinges
	(command-s "attdia" "0")
	(command-s "-layer" "set" "deets" "")
	(c:snapcircle)
	(command "-insert" "hinge_section_desmond.dwg" "explode" "yes" pause "" "" 0)
	(c:snapreset))

(defun c:keku () ; block keku clip
	(command-s "attdia" "0")
	(command-s "-layer" "set" "deets" "")
	(c:snapcircle)
	(command "-insert" "des_kekuclip.dwg" "explode" "yes" pause "" "" 0)
	(c:snapreset))

(defun c:5khngdes () ; block section view hinges
	(command-s "attdia" "0")
	(command-s "-layer" "set" "deets" "")
	(c:snapcircle)
	(command "-insert" "des_5kHinge.dwg" "explode" "yes" pause "" "" 0)
	(c:snapreset))

(defun c:doorpdes () ; block door swing plan view
	(command-s "attdia" "0")
	(command-s "-layer" "set" "wall" "")
	(command "-insert" "door_plan_desmond.dwg" "explode" "yes" pause "" "" pause)
	(command-s "-layer" "set" "dim" "")
	(command "qleader" pause pause "" "ADA CLR" ""))

(defun c:dooredes () ; block door elevation view
	(command-s "attdia" "0")
	(command-s "-layer" "set" "wall" "")
	(command "-insert" "door_elev_desmond.dwg" "explode" "yes" pause "" "" 0))

(defun c:windowpdes () ; block plan view window
	(command-s "attdia" "0")
	(command-s "-layer" "set" "wall" "")
	(command "-insert" "window_plan_desmond.dwg" "explode" "yes" pause "" "" pause))

(defun c:breakdes () ; block break at 5"
	(command-s "attdia" "0")
	(command-s "-layer" "set" "wall" "")
	(command "-insert" "breakline_desmond.dwg" "explode" "yes" pause "" "" pause))

(defun c:brkhorz () ; block break no legs horizontal
	(command-s "attdia" "0")
	(command-s "-layer" "set" "wall" "")
	(command "-insert" "breakline_horz_part.dwg" "explode" "yes" pause "" "" pause))

(defun c:brkvert () ; block break no legs vertical
	(command-s "attdia" "0")
	(command-s "-layer" "set" "wall" "")
	(command "-insert" "breakline_vert_part.dwg" "explode" "yes" pause "" "" pause))

(defun c:adan () ; block textbox 28 ada clear note
	(setq ds (getvar "dimscale"))
	(command-s "-layer" "set" "dim" "")
	(command "-insert" "28_ada_note.dwg" pause ds ds 0))

(defun c:plums () ; block textbox plam undermount sink note
	(setq ds (getvar "dimscale"))
	(command-s "-layer" "set" "dim" "")
	(command "-insert" "plam_um_note.dwg" "explode" "yes" pause ds ds 0))

(defun c:s1p () ; block generic sink plan drop in
	(command-s "-layer" "set" "deets" "")
	(command "-insert" "s1p.dwg" pause "" "" pause))

(defun c:s1e () ; block generic sink elev drop in
	(command-s "-layer" "set" "deets" "")
	(command "-insert" "s1e.dwg" pause "" "" 0))

(defun c:s2p () ; block generic sink plan drop in
	(command-s "-layer" "set" "deets" "")
	(command "-insert" "s2p.dwg" pause "" "" pause))

(defun c:s2e () ; block generic sink elev drop in
	(command-s "-layer" "set" "deets" "")
	(command "-insert" "s2e.dwg" pause "" "" 0))

(defun c:s3p () ; block generic sink plan drop in
	(command-s "-layer" "set" "deets" "")
	(command "-insert" "s2p.dwg" pause "" 0))

(defun c:s3e () ; block generic sink elev drop in
	(command-s "-layer" "set" "deets" "")
	(command "-insert" "s3e.dwg" pause "" "" 0))

(defun c:s4p () ; block generic sink plan drop in
	(command-s "-layer" "set" "deets" "")
	(command "-insert" "s4p.dwg" pause "" "" 0))

(defun c:s4e () ; block generic sink elev drop in
	(command-s "-layer" "set" "deets" "")
	(command "-insert" "s4e.dwg" pause "" "" 0))

(defun c:alrt () ; block alignment bug
	(setq ds (getvar "dimscale"))
	(command-s "-layer" "set" "dim" "")
	(command "-insert" "des_alignbug.dwg" "explode" "yes" pause ds ds pause))

(defun c:lkb () ; lockgroup label elevation view
	(command-s "-layer" "set" "dim" "")
	(command "-insert" "lockgroup.dwg" pause "" "" "")
	(command-s "_eattedit" "last"))

(defun c:tjb () ; tightjoint bolts plan view
	(command-s "-layer" "set" "deets" "")
	(command "-insert" "des_tightbolts.dwg" "explode" "yes" pause "" "" pause))

(defun c:pbp () ; pocketbore plan view, dynamic block
	(command-s "-layer" "set" "deets" "")
	(command "-insert" "des_pocketbore planview.dwg" "explode" "yes" pause "" "" pause))

(defun c:ftp () ; gooseneck faucet plan view
	(command-s "-layer" "set" "deets" "")
	(command "-insert" "des_faucet plan view.dwg" pause "" "" pause))

(defun c:fte () ; gooseneck faucet elevation view
	(command-s "-layer" "set" "deets" "")
	(command "-insert" "des_faucet elev view.dwg" pause "" "" ""))

(defun c:fts () ; gooseneck faucet section view
	(command-s "-layer" "set" "deets" "")
	(command "-insert" "des_faucetSection.dwg" pause "" "" ""))

(defun c:out2 () ; electrical outlet 2 port elevation view
	(command "-insert" "out2.dwg" pause "" "" 0))

(defun c:out4 () ; electrical outlet 4 port elevation view
	(command "-insert" "out4.dwg" pause "" "" 0))

(defun c:dat2 () ; data outlet 2 port elevation view
	(command "-insert" "data2.dwg" pause "" "" 0))

(defun c:dat4 () ; data outlet 4 port elevation view
	(command "-insert" "data4.dwg" pause "" "" 0))

(defun c:outleft () ; data outlet side view
	(command "-insert" "outleft.dwg" pause "" "" 0))

(defun c:outtop () ; data outlet plan view
	(command "-insert" "outtop.dwg" pause "" "" 0))

(defun c:335 () ; CT to 33.5" AFF for ADA drop in sink
	(setq ds (getvar "dimscale"))
	(command-s "-layer" "set" "dim" "")
	(command "-insert" "335sinknote.dwg" "explode" "yes" pause ds ds 0))

(defun c:clt () ; Centerline tag
	(command-s "-layer" "set" "dim" "")
	(setq ds (getvar "dimscale"))
	(command "-insert" "cltag.dwg" pause ds ds 0))

(defun c:sbd () ; Section Bug Dynamic
	(command-s "-layer" "set" "dim" "")
	(setq ds (getvar "dimscale"))
	(command "-insert" "des_sbd.dwg" "explode" "yes" pause ds ds 0))

(defun c:faae () ; block faucet elevation view
	(command-s "-layer" "set" "deets" "")
	(command "-insert" "des_faucetElev.dwg" "explode" "yes" pause 1 1 0))

(defun c:faaf () ; block faucet plan view
	(command-s "-layer" "set" "deets" "")
	(command "-insert" "des_faucetPlan.dwg" "explode" "yes" pause 1 1 pause))

(defun c:mag () ; block magcatch
	(command-s "-layer" "set" "deets" "")
	(command "-insert" "des_magcatch.dwg" "explode" "yes" pause 1 1 0))

(defun c:biscuit () ; block for wooden biscuit
	(command-s "-layer" "set" "green" "")
	(command "-insert" "des_biscuit.dwg" "explode" "yes" pause 1 1 0))


; ================================================================================================
; ============ Views & Dimstyles =================================================================
; ================================================================================================


(defun c:fse () ; return to model tab in drawing
	(setvar "ctab" "model"))

(defun Get-Layout-List( / acadObj acDoc acDocLayouts layoutCount loopCount
                         layoutListLocal layoutListSorted layoutName layoutPosition
                         loopCountSorted) ; Created by: Lee Ambrosius
	(vl-load-com)
	(setq acadObj (vlax-get-acad-object))
	(setq acDoc (vlax-get-property acadObj 'ActiveDocument))
	(setq acDocLayouts (vlax-get-property acDoc 'Layouts))
	(setq layoutCount (vlax-get-property acDocLayouts 'Count)
		loopCount 0
		layoutListLocal (list)
		layoutListSorted (list))
	(while (> layoutCount loopCount)
		(setq layoutName (vlax-get-property (vlax-invoke-method acDocLayouts 'Item loopCount) 'Name))
		(setq layoutPosition (vlax-get-property (vlax-invoke-method acDocLayouts 'Item loopCount) 'TabOrder))
	(setq layoutListLocal (append layoutListLocal (list (list layoutPosition layoutName))))
	(setq loopCount (1+ loopCount)))
	(setq layoutCountSorted 0) ; Resort listing by TabOrder
	(while (> (length layoutListLocal) (length layoutListSorted))
		(setq loopCountSorted 0)
		(foreach layoutLocation layoutListLocal
		(progn
			(if (and (= (car layoutLocation) (length layoutListSorted)) (= (car layoutLocation) layoutCountSorted))
				(progn
					(setq layoutListSorted (append layoutListSorted (cdr (nth loopCountSorted layoutListLocal))))
					(setq layoutCountSorted (1+ layoutCountSorted))))
       (setq loopCountSorted (1+ loopCountSorted)))))
	layoutListSorted)

(defun c:nextlayout ( / layout-mem-list layout-list layoutLocation) ; Created by: Lee Ambrosius
	(setq layoutLocation 0)
	(setq layout-list (get-layout-list))
	(setq layout-mem-list (member (getvar "CTAB") layout-list))
	(if layout-mem-list
		(progn
			(setq layoutLocation (- (length layout-list) (length layout-mem-list))))
			(setq layoutLocation (1+ layoutLocation)))
	(if (>= (1+ layoutLocation) (length layout-list))
		(setvar "CTAB" (nth 0 layout-list))
		(setvar "CTAB" (nth (1+ layoutLocation) layout-list))))

(defun c:previouslayout ( / layout-mem-list layout-list layoutLocation) ; Created by: Lee Ambrosius 
	(setq layoutLocation 0)
	(setq layout-list (get-layout-list))
	(setq layout-mem-list (member (getvar "CTAB") layout-list))
	(if layout-mem-list
		(progn
			(setq layoutLocation (- (length layout-list) (length layout-mem-list))))
			(setq layoutLocation (1- layoutLocation)))
	(if (= layoutLocation 0)
		(setvar "CTAB" (nth (1- (length layout-list)) layout-list))
		(setvar "CTAB" (nth (1- layoutLocation) layout-list))))

(defun c:FirstLayout ( / layout-list layoutLocation) ; Created by: Lee Ambrosius 
	(setvar "CTAB" (nth 1 (get-layout-list))))

(defun c:LastLayout ( / layout-list) ; Created by: Lee Ambrosius 
	(setq layout-list (get-layout-list))
	(setvar "CTAB" (nth (- (length layout-list) 1) layout-list)))

(defun c:sty1-8()
	(command-s "-dimstyle" "r" "1-8"))

(defun c:sty3-16()
	(command-s "-dimstyle" "r" "3-16"))

(defun c:sty1-4()
	(command-s "-dimstyle" "r" "1-4"))

(defun c:sty3-8()
	(command-s "-dimstyle" "r" "3-8"))

(defun c:sty3-8dat()
	(command-s "-dimstyle" "r" "3-8 DATUM"))

(defun c:sty1-2()
	(command-s "-dimstyle" "r" "1-2"))

(defun c:sty3-4()
	(command-s "-dimstyle" "r" "3-4"))

(defun c:sty1()
	(command-s "-dimstyle" "r" "1"))

(defun c:sty1-1-2()
	(command-s "-dimstyle" "r" "1 1-2"))

(defun c:sty2()
	(command-s "-dimstyle" "r" "2"))

(defun c:sty3()
	(command-s "-dimstyle" "r" "3"))

(defun c:sty6()
	(command-s "-dimstyle" "r" "6"))

(defun c:sty12()
	(command-s "-dimstyle" "r" "12"))

(defun c:z96 () ; .125"
	(command-s "zoom" "s" "1/96xp"))

(defun c:z72 ()
	(command-s "zoom" "s" "1/72xp"))

(defun c:z64 () ; .1875"
	(command-s "zoom" "s" "1/64xp"))

(defun c:z48 () ; .25"
	(command-s "zoom" "s" "1/48xp"))

(defun c:z32 () ; .375"
	(command-s "zoom" "s" "1/32xp"))

(defun c:z24 () ; .5"
	(command-s "zoom" "s" "1/24xp"))

(defun c:z16 () ; .75"
	(command-s "zoom" "s" "1/16xp"))

(defun c:z12 () ; 1"
	(command-s "zoom" "s" "1/12xp"))

(defun c:z8 () ; 1.5"
	(command-s "zoom" "s" "1/8xp"))

(defun c:z6 () ; 2
	(command-s "zoom" "s" "1/6xp"))

(defun c:z4 () ; 3
	(command-s "zoom" "s" "1/4xp"))

(defun c:z2 () ; 6
	(command-s "zoom" "s" "1/2xp"))

(defun c:z1 () ; 12
	(command-s "zoom" "1xp"))

(defun c:cameraTop () ; reset view to top down view
	(command-s "-view" "_top"))

(defun c:cameraNorth() 
	(command-s "-view" "back"))

(defun c:cameraEast() 
	(command-s "-view" "right"))

(defun c:cameraSouth() 
	(command-s "-view" "front"))

(defun c:cameraWest() 
	(command-s "-view" "left"))

(defun c:cameraIsoNW() 
	(command-s "-view" "nw"))

(defun c:cameraIsoNE() 
	(command-s "-view" "ne"))

(defun c:cameraIsoSW() 
	(command-s "-view" "sw"))

(defun c:cameraIsoSE() 
	(command-s "-view" "se"))


; ================================================================================================
; ============ Dimension Modifiers ===============================================================
; ================================================================================================


(defun c:ed1 ()
	(command-s "dimedit" "n" "<>"))

(defun c:edm ()
	(command-s "dimedit" "n" "<> MIN"))

(defun c:edmm ()
	(command-s "dimedit" "n" "<>\nMIN"))

(defun c:edg ()
	(command-s "dimedit" "n" "<> GAP"))

(defun c:edgg ()
	(command-s "dimedit" "n" "<>\nGAP"))

(defun c:ede ()
	(command-s "dimedit" "n" "<> EQ"))

(defun c:edee ()
	(command-s "dimedit" "n" "<>\nEQ"))

(defun c:edleg ()
	(command-s "dimedit" "n" "<> LEG"))

(defun c:edlegg ()
	(command-s "dimedit" "n" "<>\nLEG"))

(defun c:edk ()
	(command-s "dimedit" "n" "<> KICK"))

(defun c:eddeck ()
	(command-s "dimedit" "n" "<> DECK"))

(defun c:eddeckk ()
	(command-s "dimedit" "n" "<>\nDECK"))

(defun c:edsub ()
	(command-s "dimedit" "n" "<> SUBTOP"))

(defun c:edsubb ()
	(command-s "dimedit" "n" "<>\nSUB\nTOP"))

(defun c:edsil ()
	(command-s "dimedit" "n" "<> SILL"))

(defun c:edsill ()
	(command-s "dimedit" "n" "<>\nSILL"))

(defun c:edsof ()
	(command-s "dimedit" "n" "<> SOFFIT"))

(defun c:edsoff ()
	(command-s "dimedit" "n" "<>\nSOFFIT"))

(defun c:edsv () 
	(command-s "dimedit" "n" "<> VIF SOFFIT"))

(defun c:edsvv ()
	(command-s "dimedit" "n" "<>\nVIF\nSOFFIT"))

(defun c:edov ()
	(command-s "dimedit" "n" "<> OVERALL"))

(defun c:edovv ()
	(command-s "dimedit" "n" "<>\nOVER\nALL"))

(defun c:edtyp ()
	(command-s "dimedit" "n" "<> TYP."))

(defun c:edtypp ()
	(command-s "dimedit" "n" "<>\nTYP."))

(defun c:edshelf ()
	(command-s "dimedit" "n" "<> SHELVES"))

(defun c:edshelff ()
	(command-s "dimedit" "n" "<>\nSHELVES"))

(defun c:edapron ()
	(command-s "dimedit" "n" "<> APRON"))

(defun c:edapronn ()
	(command-s "dimedit" "n" "<>\nAPRON"))

(defun c:edt ()
	(command-s "dimedit" "n" "<> TOP"))

(defun c:edtt ()
	(command-s "dimedit" "n" "<>\nTOP"))

(defun c:edv ()
	(command-s "dimedit" "n" "<> VIF"))

(defun c:edvv ()
	(command-s "dimedit" "n" "<>\nVIF"))

(defun c:edc ()
	(command-s "dimedit" "n" "<> CLR"))

(defun c:edcc ()
	(command-s "dimedit" "n" "<>\nCLR"))

(defun c:eds ()
	(command-s "dimedit" "n" "<> SCRIBE"))

(defun c:edws ()
	(command-s "dimedit" "n" "<>\nWINDOW\nSILL"))


; ================================================================================================
; ============ Leaders ===========================================================================
; ================================================================================================


(defun c:setBaseDepth ()
	(setq typBaseDepth (getreal (strcat "Current base depth: " (formatDimsForLeader typBaseDepth) "\nInput new depth:")))
	(c:bst))

(defun c:setTallDepth ()
	(setq typTallDepth (getreal (strcat "Current tall depth: " (formatDimsForLeader typTallDepth) "\nInput new depth:")))
	(c:tst))

(defun c:setUpperDepth ()
	(setq typUpperDepth (getreal (strcat "Current upper depth: " (formatDimsForLeader typUpperDepth) "\nInput new depth:")))
	(c:ut))

(defun c:setCtDepth ()
	(setq typCTDepth (getreal (strcat "Current countertop depth: " (formatDimsForLeader typCTDepth) "\nInput new depth:")))
	(c:cst))

(defun c:setSplashHeight ()
	(setq typSplashHeight (getreal (strcat "Current splash height: " (formatDimsForLeader typSplashHeight) "\nInput new height:"))))

(defun c:setValanceHeight ()
	(setq typValanceHeight (getreal (strcat "Current valance height: " (formatDimsForLeader typValanceHeight) "\nInput new height:")))
	(c:lv))

(defun strToColorBug (str)
	(setq dtctMat (substr str 2)) ; trim first char off str which should always be '/', use this to determine finish
	(if (wcmatch (substr dtctMat 1 1) "#") ; check if PLAM
		(setq mat "pl" fin (substr dtctMat 1))
		(progn
			(setq fin (substr dtctMat 2)) ; if not PLAM, then finish is the character after FIRST
			(if (wcmatch dtctMat "/#")
				(setq mat "ss")
				(if (wcmatch dtctMat "`*#")
					(setq mat "ssm")
					(if (wcmatch dtctMat "`-#")
						(setq mat "qtz"))))))
	(setq filepath (strcat "colorbug_des_" mat fin ".dwg")))

(defun leaderAndColorbug (cabValue leaderText xVal yVal)
	(setq p1 (getpoint "Point, arrow") 
		  p2 (getpoint "Point, text") 
		  cl (getvar "clayer") 
		  ds (getvar "dimscale") 
		  scaleOffset (getScaleOffset) 
		  ;textSide (if (minsup (- (car p2) (car p1)))
		  ;	 (-1) (1))
		  textLen (if (/= nil cabValue) 
					(strlen (formatDimsForLeader cabValue)) (0)))
	(if (minusp (- (car p2) (car p1)))
		(setq textSide -1)
		(setq textSide 1))

	(setq xOffset (* textSide (+ (* textLen 0.446) (* scaleOffset xVal)))); TODO: need to refine this equation of finding str len
	(setq yOffset (* scaleOffset yVal))
	(command-s "attdia" "0")
	(command-s "-layer" "set" "dim" "")
	(command "qleader" p1 p2 "" (strcat (formatDimsForLeader cabValue) leaderText) "")
	(setq bugName (strToColorBug (getstring "Enter a color bug comand")))
	(command "-insert" bugName "explode" "yes" p2 ds ds "")
	(command-s "move" "last" "" '(0 0) (list xOffset yOffset))
	(command-s "-layer" "set" cl "")) 

(defun c:bst () ; leader typical base cabinets
	(leaderAndColorbug typBaseDepth " DEEP \nBASE CABINETS" 3.69246 leaderUp))

(defun c:tst () ; leader typical tall cabinets
	(leaderAndColorbug typTallDepth " DEEP \nTALL CABINETS" 5 leaderUp))

(defun c:ut () ; leader typical upper cabinets
	(leaderAndColorbug typUpperDepth " DEEP \nUPPER CABINETS" 3.69246 leaderUp))

(defun c:cst () ; leader typical countertop
	(leaderAndColorbug typCTDepth " DEEP \nCOUNTERTOP" 5 leaderUp))

(defun c:4scs () ; leader smartclip splash
	(leaderAndColorbug typSplashHeight " SMARTCLIP\nSPLASH" 3.69246 leaderDown))

(defun c:4is () ; leader integral splash
	(leaderAndColorbug typSplashHeight " INTEGERAL\nSPLASH" 3.69246 leaderDown))

(defun c:4st () ; leader typical topset splash
	(leaderAndColorbug typSplashHeight " TOPSET\nSPLASH" 3.6 leaderDown))

(defun c:rbt () ; leader rubber base
	(command-s "-layer" "set" "dim" "")
	(command "qleader" pause pause "" "BASE BY OTHERS, \nAS SCHEDULED" ""))

(defun c:pbt () ; leader plam base
	(command-s "-layer" "set" "dim" "")
	(command "qleader" pause pause "" "PLAM \nTOE BASE" ""))

(defun c:pst () ; leader soffit
	(command-s "-layer" "set" "dim" "")
	(command "qleader" pause pause "" "SOFFIT" ""))

(defun c:flst () ; leader flush soffit
	(leaderAndColorbug nil "FLUSH\nSOFFIT" 3 leaderUp))
	;(command-s "-layer" "set" "dim" "")
	;(command "qleader" pause pause "" " ""))

(defun c:ast () ; adjustable shelf
	(command-s "-layer" "set" "dim" "")
	(command "qleader" pause pause "" "ADJ. SHELF" ""))

(defun c:astt () ; adjustable shelf stacked
	(command-s "-layer" "set" "dim" "")
	(command "qleader" pause pause "" "ADJ. SHELF" ""))

(defun c:lv () ; light valance & leader
	(command-s "-layer" "set" "hidden" "")
	(command "line" pause pause "")
	(setq valanceOffset (getreal "Input valance height:\nLeave blank for default"))
	(if (/= valanceOffset nil)
		(setq offsetStr (formatDimsForLeader valanceOffset))
		(setq offsetStr (formatDimsForLeader typValanceHeight)))
	(command-s "move" "last" "" "0,0" (strcat "0," offsetStr))
	(command-s "-layer" "set" "dim" "")
	(command "qleader" pause pause "" (strcat offsetStr " LIGHT \nVALANCE" ) ""))

(defun c:lkt () ; leader lock
	(command-s "-layer" "set" "dim" "")
	(command "qleader" pause pause "" "LOCK, TYP." ""))

(defun c:fb () ; leader finished bottom
	(command-s "-layer" "set" "dim" "")
	(command "qleader" pause pause "" "FB" ""))

(defun c:qt () ; hidden text, leader only visible 
	(command "-layer" "set" "dim" "")
	(command "qleader" pause pause "" "invisible" "")
	(command "chprop" "last" "" "C" "T" "0,0,0" "")
	(command "chprop" "last" "" "layer" "defpoints" "")
	(command "draworder" "last" "" "back"))

(defun c:iwt () ; leader in wall bracket
	(command-s "-layer" "set" "dim" "")
	(command "qleader" pause pause "" "IN-WALL" "SUPPORT" ""))


; ================================================================================================
; ============ Color Bugs ========================================================================
; ================================================================================================


(defun insertColorBug (filepath) ; function insert color bug
	(setq insertPoint (getpoint))
	(command-s "attdia" "0")
	(setq cl (getvar "clayer"))
	(setq ds (getvar "dimscale"))
	(command-s "-layer" "set" "dim" "")
	(command-s "-insert" filepath "explode" "yes" insertPoint ds ds "")
	(command-s "-layer" "set" cl ""))

(defun c:/0 () ; plam blank
	(insertColorBug "colorbug_des_pl0.dwg"))

(defun c:/1 () ; plam 1
	(insertColorBug "colorbug_des_pl1.dwg"))

(defun c:/2 ()
	(insertColorBug "colorbug_des_pl2.dwg"))

(defun c:/3 ()
	(insertColorBug "colorbug_des_pl3.dwg"))

(defun c:/4 ()
	(insertColorBug "colorbug_des_pl4.dwg"))

(defun c:/5 ()
	(insertColorBug "colorbug_des_pl5.dwg"))

(defun c:/6 ()
	(insertColorBug "colorbug_des_pl6.dwg"))

(defun c:/7 ()
	(insertColorBug "colorbug_des_pl7.dwg"))

(defun c:/8 ()
	(insertColorBug "colorbug_des_pl8.dwg"))

(defun c:/9 ()
	(insertColorBug "colorbug_des_pl9.dwg"))

(defun c:/10 ()
	(insertColorBug "colorbug_des_pl10.dwg"))

(defun c://0 ()
	(insertColorBug "colorbug_des_ss0.dwg"))

(defun c://1 ()
	(insertColorBug "colorbug_des_ss1.dwg"))

(defun c://2 () 
	(insertColorBug "colorbug_des_ss2.dwg"))

(defun c://3 ()
	(insertColorBug "colorbug_des_ss3.dwg"))

(defun c://4 ()
	(insertColorBug "colorbug_des_ss4.dwg"))

(defun c://5 ()
	(insertColorBug "colorbug_des_ss5.dwg"))

(defun c://6 ()
	(insertColorBug "colorbug_des_ss6.dwg"))

(defun c:/*1 () ; SSM-1
	(insertColorBug "colorbug_des_ssm1.dwg"))

(defun c:/*2 () ; SSM-2
	(insertColorBug "colorbug_des_ssm2.dwg"))

(defun c:/-1 ()
	(insertColorBug "colorbug_des_qtz1.dwg"))

(defun c:/-2 ()
	(insertColorBug "colorbug_des_qtz2.dwg"))



; ================================================================================================
; ============ Layer Changes =====================================================================
; ================================================================================================


(defun desChangeColor (color trueColorValue) ; color change function
	;(if (setq p1 (cadr (ssgetfirst)))
	(if (setq p1 (ssget "_:L"))
		(if (/= color "T")
			(progn (sssetfirst) (command-s "chprop" p1 "" "C" color ""))
			(progn (sssetfirst) (command-s "chprop" p1 "" "C" color trueColorValue "")))
	(princ)))

(defun desLayerChange (layerName / sel)
	(if (setq sel (ssget "_:L"))
		(command-s "_.chprop" sel "" "_la" layerName "")
		(princ "\nNo objects found.")))

(defun c:111 () ; solid purple layer
	(desLayerChange "lines"))

(defun c:222 () ; solid yellow layer, hardware
	(desLayerChange "deets"))

(defun c:333 () ; solid green Layer
	(desLayerChange "green"))

(defun c:444 () ; solid light blue layer, countertops
	(desLayerChange "tops"))

(defun c:555 () ; solid blue layer, walls
	(desLayerChange "wall"))

(defun c:666 () ; solid orange layer, special
	(desLayerChange "splash"))

(defun c:777 () ; solid white layer, casework
	(desLayerChange "cases"))

(defun c:888 () ; dashed grey layer, hidden
	(desLayerChange "hidden"))

(defun c:999 () ; dashed purple layer, phantom
	(desLayerChange "phantom"))

(defun c:``` () ; solid invisible layer, defpoints
	(desLayerChange "defpoints"))

(defun c:ggg () ; solid teal layer, glass
	(desLayerChange "glass"))

(defun c:www () ; phantom layer wainscot 1mm thick
	(desLayerChange "wainscot"))

(defun c:bbb () ; 2D base layer
	(desLayerChange "2d_base"))

(defun c:ttt () ; 2D upper layer
	(desLayerChange "2d_upper"))

(defun c:clrred () ; change color to red
	(desChangeColor 1 NULL))

(defun c:clryellow () ; change color to yellow
	(desChangeColor 2 NULL))

(defun c:clrblue () ; change color to blue
	(desChangeColor 5 NULL))

(defun c:clrgreen () ; change color to green
	(desChangeColor 3 NULL))

(defun c:clrblack () ; change color to black
	(desChangeColor "T" "0,0,0"))

(defun c:clreset () ; reset color to by layer
	(desChangeColor "bylayer" NULL))

(defun c:clrvanish () ; change target to defpoints & make match background color
	(setq usersel (UserSelect 0))
	(UserCancel)
	(command-s "chprop" usersel "" "C" "T" "0,0,0" "layer" "defpoints"))

; ================================================================================================
; ============ Final =============================================================================
; ================================================================================================

(defun c:lastTest ()
	(display-msg "All lisps have been successfully loaded." 1))
