; replace SpritePrep_Eyegore if flag is on
SpritePrep_EyegoreNew:
{
    LDA !ENABLE_MIMIC_OVERRIDE : BNE .new
        ; old
        JSL SpritePrep_Eyegore
        RTL

    .new
    LDA $0E20, X : CMP.b #$B8 : BEQ .mimic ;If sprite id == debugger sprite
        JSL $1EC71A ; 0xF471A set eyegore to be only eyegore (.not_goriya?)
    RTL
    .mimic
        LDA #$83 : STA $0E20, X : JSL $0DB818 ; 0x6B818 Sprite_LoadProperties of green eyegore
        LDA #$B8 : STA $0E20, X ; set the sprite back to mimic
        LDA $0CAA, X : AND #$FB : ORA #$80 : STA $0CAA, X ; STZ $0CAA, X
        ;INC $0DA0, X
        JSL $1EC70D ;0xF470D set eyegore to be mimic (.is_goriya?)
RTL
}

resetSprite_Mimic:
{
    LDA !ENABLE_MIMIC_OVERRIDE : BEQ .notMimic ; skip to what it would have done normally

    LDA $0E20, X
    CMP.b #$B8 : BNE .notMimic
    LDA #$83 : STA $0E20, X ; overwrite the sprite id with green eyegore id

.notMimic
    ; restore code
    LDA $0E20, X
    
    CMP.b #$7A

RTL
}

notItemSprite_Mimic:
{ ; don't change this unless you go update SetKillableThief in c# side since it assumes +4 bytes to update the value on the CMP from B8 to C4
    ; if we set killable thief we want to update the sprite id so it can be killed
    LDA $0E20, X
    CMP.b #$B8 : BEQ .changeSpriteId ; thief #$C4

    ; if we don't have mimic code turned on we want to skip, but we also need to reload the sprite id because we just smoked it with this LDA
    LDA !ENABLE_MIMIC_OVERRIDE : BEQ .reloadSpriteIdAndSkipMimic ; skip to what it would have done normally

    LDA $0E20, X ; I hate assembly
    CMP.b #$B8 : BNE .continue      ; "mimic" (dialogue test sprite we hijacked). skip to vanilla behavior if it's not a "mimic"

.changeSpriteId
    LDA #$83 ; load green eyegore sprite id so we can kill the thing
    JMP .continue

.reloadSpriteIdAndSkipMimic
    LDA $0E20, X

.continue

    ; restore code
    REP #$20 : ASL #2
    ;REP #$20 : ASL #4 : ORA $0CF2 : PHX : REP #$10 : TAX
    ;SEP #$20
    ;LDA $7F6000, X : STA $02
    ;SEP #$10

RTL
}