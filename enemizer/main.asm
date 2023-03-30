; Intended to be a migration of code generated by enemizer

lorom

;================================================================================

!ADD = "CLC : ADC"
!SUB = "SEC : SBC"
!BLT = "BCC"
!BGE = "BCS"

;=Constants======================================================================

!BUSHES_FLAG = "$368100"
!BLIND_DOOR_FLAG = "$368101"
!MOLDORM_EYES_FLAG = "$368102"
!RANDOM_SPRITE_FLAG = "$368103"
!AGAHNIM_FUN_BALLS = "$368104"
!ENABLE_MIMIC_OVERRIDE = "$368105"
;!ENABLE_TERRORPIN_AI_FIX = "$368106" # moved to baserom already
!CENTER_BOSS_DROP_FLAG = "$368107"
!KILLABLE_THIEVES_ID = "$368108"

; Enemizer reserved memory
; $7F50B0 - $7F50BF - Downstream Reserved (Enemizer)
!SHELL_DMA_FLAG = "$7F50B0"
!SOUNDFX_LOADED = "$7F50B1"
;================================================================================

incsrc hooks.asm
incsrc DMA.asm

org $B68000 ; the original org is 368000 and B6 is the same bank but fastrom
EnemizerTablesStart:
incsrc enemizer_info_table.asm ; B68000-B680FF
incsrc enemizerflags.asm  ; B68100-B6811F
incsrc bushes_table.asm   ; B68120-B6373

EnemizerCodeStart:
incsrc bushes.asm
incsrc NMI.asm
incsrc special_action.asm
incsrc bosses_moved.asm
incsrc damage.asm
incsrc bossdrop.asm
incsrc moldorm.asm
incsrc kodongo_fixes.asm
incsrc mimic_fixes.asm
; vitreous key fix for boss shuffle - uses FixPrizeOnTheEyes flag

incsrc overworld_sprites.asm
incsrc underworld_sprites.asm

incsrc blindboss.asm

incsrc shell_gfx.asm
warnpc $B6FFFF ;if we hit this we need to split stuff by bank

org $0684BD
Sprite_Get16BitCoords_long:

org $1EC6FA ;F46FA
SpritePrep_Eyegore: