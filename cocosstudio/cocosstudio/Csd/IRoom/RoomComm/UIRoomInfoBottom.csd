<GameFile>
  <PropertyGroup Name="NodeRoomInfoUI" Type="Node" ID="67a59c3e-739a-4249-95e4-5ff4f5722af3" Version="3.10.0.0" />
  <Content ctype="GameProjectContent">
    <Content>
      <Animation Duration="60" Speed="1.0000" ActivedAnimationName="run">
        <Timeline ActionTag="44780064" Property="Alpha">
          <IntFrame FrameIndex="0" Value="255">
            <EasingData Type="0" />
          </IntFrame>
          <IntFrame FrameIndex="30" Value="0">
            <EasingData Type="0" />
          </IntFrame>
          <IntFrame FrameIndex="60" Value="255">
            <EasingData Type="0" />
          </IntFrame>
        </Timeline>
        <Timeline ActionTag="1367852427" Property="Alpha">
          <IntFrame FrameIndex="0" Value="255">
            <EasingData Type="0" />
          </IntFrame>
          <IntFrame FrameIndex="30" Value="0">
            <EasingData Type="0" />
          </IntFrame>
          <IntFrame FrameIndex="60" Value="255">
            <EasingData Type="0" />
          </IntFrame>
        </Timeline>
        <Timeline ActionTag="-286298367" Property="Alpha">
          <IntFrame FrameIndex="0" Value="255">
            <EasingData Type="0" />
          </IntFrame>
          <IntFrame FrameIndex="30" Value="0">
            <EasingData Type="0" />
          </IntFrame>
          <IntFrame FrameIndex="60" Value="255">
            <EasingData Type="0" />
          </IntFrame>
        </Timeline>
        <Timeline ActionTag="1304272277" Property="Alpha">
          <IntFrame FrameIndex="0" Value="255">
            <EasingData Type="0" />
          </IntFrame>
          <IntFrame FrameIndex="30" Value="0">
            <EasingData Type="0" />
          </IntFrame>
          <IntFrame FrameIndex="60" Value="255">
            <EasingData Type="0" />
          </IntFrame>
        </Timeline>
      </Animation>
      <AnimationList>
        <AnimationInfo Name="run" StartIndex="0" EndIndex="60">
          <RenderColor A="255" R="70" G="130" B="180" />
        </AnimationInfo>
      </AnimationList>
      <ObjectData Name="Node" Tag="201" ctype="GameNodeObjectData">
        <Size X="0.0000" Y="0.0000" />
        <Children>
          <AbstractNodeData Name="imgDeskCloth" ActionTag="-943621438" Tag="756" IconVisible="False" PositionPercentXEnabled="True" PositionPercentYEnabled="True" LeftMargin="-640.0000" RightMargin="-640.0000" TopMargin="-360.0000" BottomMargin="-360.0000" Scale9Enable="True" LeftEage="422" RightEage="422" TopEage="237" BottomEage="237" Scale9OriginX="422" Scale9OriginY="237" Scale9Width="436" Scale9Height="246" ctype="ImageViewObjectData">
            <Size X="1280.0000" Y="720.0000" />
            <Children>
              <AbstractNodeData Name="imgGameLogo" ActionTag="-506638357" VisibleForFrame="False" Tag="6180" IconVisible="False" PositionPercentXEnabled="True" PositionPercentYEnabled="True" LeftMargin="479.5000" RightMargin="479.5000" TopMargin="154.5000" BottomMargin="514.5000" LeftEage="105" RightEage="105" TopEage="16" BottomEage="16" Scale9OriginX="105" Scale9OriginY="16" Scale9Width="111" Scale9Height="19" ctype="ImageViewObjectData">
                <Size X="321.0000" Y="51.0000" />
                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                <Position X="640.0000" Y="540.0000" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition X="0.5000" Y="0.7500" />
                <PreSize X="0.2508" Y="0.0708" />
                <FileData Type="MarkedSubImage" Path="Image/IRoom/RoomCenter/CenterGameLogo.png" Plist="Texture/IRoom/RoomCenter.plist" />
              </AbstractNodeData>
            </Children>
            <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
            <Position />
            <Scale ScaleX="1.0000" ScaleY="1.0000" />
            <CColor A="255" R="255" G="255" B="255" />
            <PrePosition />
            <PreSize X="0.0000" Y="0.0000" />
            <FileData Type="Normal" Path="Image/BigImg/game_bg3.png" Plist="" />
          </AbstractNodeData>
          <AbstractNodeData Name="layoutCenter" ActionTag="-496031889" Tag="1139" IconVisible="False" PositionPercentXEnabled="True" PositionPercentYEnabled="True" LeftMargin="-100.0000" RightMargin="-100.0000" TopMargin="-100.0000" BottomMargin="-100.0000" ClipAble="False" BackColorAlpha="102" ColorAngle="90.0000" Scale9Width="1" Scale9Height="1" ctype="PanelObjectData">
            <Size X="200.0000" Y="200.0000" />
            <Children>
              <AbstractNodeData Name="btnMessage" ActionTag="-1909216288" Tag="1141" IconVisible="False" PositionPercentXEnabled="True" PositionPercentYEnabled="True" LeftMargin="641.0000" RightMargin="-519.0000" TopMargin="95.8000" BottomMargin="26.2000" TouchEnable="True" FontSize="14" Scale9Enable="True" LeftEage="15" RightEage="15" TopEage="11" BottomEage="11" Scale9OriginX="15" Scale9OriginY="11" Scale9Width="48" Scale9Height="56" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="ButtonObjectData">
                <Size X="78.0000" Y="78.0000" />
                <Children>
                  <AbstractNodeData Name="btnVoice" ActionTag="1936420549" Tag="1140" IconVisible="False" PositionPercentXEnabled="True" TopMargin="101.0000" BottomMargin="-101.0000" TouchEnable="True" FontSize="14" Scale9Enable="True" LeftEage="15" RightEage="15" TopEage="6" BottomEage="6" Scale9OriginX="15" Scale9OriginY="6" Scale9Width="48" Scale9Height="66" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="ButtonObjectData">
                    <Size X="78.0000" Y="78.0000" />
                    <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                    <Position X="39.0000" Y="-62.0000" />
                    <Scale ScaleX="1.0000" ScaleY="1.0000" />
                    <CColor A="255" R="255" G="255" B="255" />
                    <PrePosition X="0.5000" Y="-0.7949" />
                    <PreSize X="1.0000" Y="1.0000" />
                    <TextColor A="255" R="65" G="65" B="70" />
                    <PressedFileData Type="MarkedSubImage" Path="Image/IRoom/RoomCenter/BtnVoiceBlueDown.png" Plist="Texture/IRoom/RoomCenter.plist" />
                    <NormalFileData Type="MarkedSubImage" Path="Image/IRoom/RoomCenter/BtnVoiceBlueNormal.png" Plist="Texture/IRoom/RoomCenter.plist" />
                    <OutlineColor A="255" R="255" G="0" B="0" />
                    <ShadowColor A="255" R="110" G="110" B="110" />
                  </AbstractNodeData>
                </Children>
                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                <Position X="680.0000" Y="65.2000" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition X="3.4000" Y="0.3260" />
                <PreSize X="0.3900" Y="0.3900" />
                <TextColor A="255" R="65" G="65" B="70" />
                <NormalFileData Type="MarkedSubImage" Path="Image/IRoom/RoomCenter/BtnMsgBlue.png" Plist="Texture/IRoom/RoomCenter.plist" />
                <OutlineColor A="255" R="255" G="0" B="0" />
                <ShadowColor A="255" R="110" G="110" B="110" />
              </AbstractNodeData>
            </Children>
            <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
            <Position />
            <Scale ScaleX="1.0000" ScaleY="1.0000" />
            <CColor A="255" R="255" G="255" B="255" />
            <PrePosition />
            <PreSize X="0.0000" Y="0.0000" />
            <SingleColor A="255" R="150" G="200" B="255" />
            <FirstColor A="255" R="150" G="200" B="255" />
            <EndColor A="255" R="255" G="255" B="255" />
            <ColorVector ScaleY="1.0000" />
          </AbstractNodeData>
          <AbstractNodeData Name="btnInviteFriend" ActionTag="-1883338033" VisibleForFrame="False" Tag="1050" IconVisible="False" PositionPercentXEnabled="True" PositionPercentYEnabled="True" LeftMargin="-118.0000" RightMargin="-118.0000" TopMargin="-36.5000" BottomMargin="-36.5000" TouchEnable="True" FontSize="14" LeftEage="15" RightEage="15" TopEage="11" BottomEage="11" Scale9OriginX="15" Scale9OriginY="11" Scale9Width="206" Scale9Height="51" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="ButtonObjectData">
            <Size X="236.0000" Y="73.0000" />
            <Children>
              <AbstractNodeData Name="btnCopyRoomID" ActionTag="-662353964" Tag="1051" IconVisible="False" PositionPercentXEnabled="True" LeftMargin="0.5000" RightMargin="0.5000" TopMargin="73.0000" BottomMargin="-73.0000" TouchEnable="True" FontSize="14" LeftEage="15" RightEage="15" TopEage="11" BottomEage="11" Scale9OriginX="15" Scale9OriginY="11" Scale9Width="205" Scale9Height="51" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="ButtonObjectData">
                <Size X="235.0000" Y="73.0000" />
                <AnchorPoint ScaleX="0.5000" ScaleY="1.0000" />
                <Position X="118.0000" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition X="0.5000" />
                <PreSize X="0.9958" Y="1.0000" />
                <TextColor A="255" R="65" G="65" B="70" />
                <NormalFileData Type="MarkedSubImage" Path="Image/IRoom/RoomCenter/CenterBtnCopyRoomID.png" Plist="Texture/IRoom/RoomCenter.plist" />
                <OutlineColor A="255" R="255" G="0" B="0" />
                <ShadowColor A="255" R="110" G="110" B="110" />
              </AbstractNodeData>
            </Children>
            <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
            <Position />
            <Scale ScaleX="1.0000" ScaleY="1.0000" />
            <CColor A="255" R="255" G="255" B="255" />
            <PrePosition />
            <PreSize X="0.0000" Y="0.0000" />
            <TextColor A="255" R="65" G="65" B="70" />
            <NormalFileData Type="MarkedSubImage" Path="Image/IRoom/RoomCenter/CenterBtnInvert.png" Plist="Texture/IRoom/RoomCenter.plist" />
            <OutlineColor A="255" R="255" G="0" B="0" />
            <ShadowColor A="255" R="110" G="110" B="110" />
          </AbstractNodeData>
          <AbstractNodeData Name="btnReady" ActionTag="1355559171" Tag="1229" IconVisible="False" PositionPercentXEnabled="True" LeftMargin="-92.5000" RightMargin="-92.5000" TopMargin="167.7500" BottomMargin="-233.7500" TouchEnable="True" FontSize="36" LeftEage="15" RightEage="15" TopEage="11" BottomEage="11" Scale9OriginX="15" Scale9OriginY="11" Scale9Width="155" Scale9Height="44" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="ButtonObjectData">
            <Size X="185.0000" Y="66.0000" />
            <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
            <Position Y="-200.7500" />
            <Scale ScaleX="1.0000" ScaleY="1.0000" />
            <CColor A="255" R="255" G="255" B="255" />
            <PrePosition />
            <PreSize X="0.0000" Y="0.0000" />
            <TextColor A="255" R="255" G="255" B="255" />
            <NormalFileData Type="MarkedSubImage" Path="Image/IRoom/CommomRoom/comm_btn_ready.png" Plist="Texture/IRoom/CommomRoom.plist" />
            <OutlineColor A="255" R="255" G="0" B="0" />
            <ShadowColor A="255" R="110" G="110" B="110" />
          </AbstractNodeData>
          <AbstractNodeData Name="btnCancelTuoGuan" ActionTag="-441744980" Tag="1317" IconVisible="False" PositionPercentXEnabled="True" LeftMargin="-68.5000" RightMargin="-68.5000" TopMargin="143.3300" BottomMargin="-188.3300" TouchEnable="True" FontSize="36" LeftEage="15" RightEage="15" TopEage="11" BottomEage="11" Scale9OriginX="15" Scale9OriginY="11" Scale9Width="107" Scale9Height="23" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="ButtonObjectData">
            <Size X="137.0000" Y="45.0000" />
            <Children>
              <AbstractNodeData Name="txtTuoGuanDesc" ActionTag="686188123" Tag="1318" IconVisible="False" PositionPercentXEnabled="True" LeftMargin="144.4952" RightMargin="-307.4952" TopMargin="1.0667" BottomMargin="-6.0667" IsCustomSize="True" FontSize="17" LabelText="托管期间系统不会自动执行摸牌，打牌，胡牌和暗杠以外的任何操作" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                <Size X="300.0000" Y="50.0000" />
                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                <Position X="294.4952" Y="18.9333" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="165" B="0" />
                <PrePosition X="2.1496" Y="0.4207" />
                <PreSize X="2.1898" Y="1.1111" />
                <OutlineColor A="255" R="255" G="0" B="0" />
                <ShadowColor A="255" R="110" G="110" B="110" />
              </AbstractNodeData>
              <AbstractNodeData Name="spriteFlagTuoGuan" ActionTag="596595333" Tag="1319" IconVisible="False" PositionPercentXEnabled="True" LeftMargin="14.0015" RightMargin="-16.0015" TopMargin="47.4999" BottomMargin="-47.4999" ctype="SpriteObjectData">
                <Size X="139.0000" Y="45.0000" />
                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                <Position X="83.5015" Y="-24.9999" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition X="0.6095" Y="-0.5556" />
                <PreSize X="1.0146" Y="1.0000" />
                <FileData Type="MarkedSubImage" Path="Image/IRoom/CommomRoom/game_flag_tuoguan.png" Plist="Texture/IRoom/CommomRoom.plist" />
                <BlendFunc Src="1" Dst="771" />
              </AbstractNodeData>
            </Children>
            <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
            <Position Y="-165.8300" />
            <Scale ScaleX="1.0000" ScaleY="1.0000" />
            <CColor A="255" R="255" G="255" B="255" />
            <PrePosition />
            <PreSize X="0.0000" Y="0.0000" />
            <TextColor A="255" R="255" G="255" B="255" />
            <NormalFileData Type="MarkedSubImage" Path="Image/IRoom/CommomRoom/game_btn_qxtg.png" Plist="Texture/IRoom/CommomRoom.plist" />
            <OutlineColor A="255" R="255" G="0" B="0" />
            <ShadowColor A="255" R="110" G="110" B="110" />
          </AbstractNodeData>
          <AbstractNodeData Name="spriteTurnPosBG" ActionTag="-1379177974" Tag="3245" IconVisible="False" PositionPercentXEnabled="True" PositionPercentYEnabled="True" LeftMargin="-71.0000" RightMargin="-71.0000" TopMargin="-71.0000" BottomMargin="-71.0000" ctype="SpriteObjectData">
            <Size X="142.0000" Y="142.0000" />
            <Children>
              <AbstractNodeData Name="spriteTurnPos1" ActionTag="44780064" Tag="3246" RotationSkewX="90.0000" RotationSkewY="90.0000" IconVisible="False" PositionPercentYEnabled="True" LeftMargin="48.8003" RightMargin="-32.8003" TopMargin="45.5000" BottomMargin="45.5000" ctype="SpriteObjectData">
                <Size X="126.0000" Y="51.0000" />
                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                <Position X="111.8003" Y="71.0000" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition X="0.7873" Y="0.5000" />
                <PreSize X="0.8873" Y="0.3592" />
                <FileData Type="MarkedSubImage" Path="Image/IRoom/RoomCenter/CenterDirectTo.png" Plist="Texture/IRoom/RoomCenter.plist" />
                <BlendFunc Src="1" Dst="771" />
              </AbstractNodeData>
              <AbstractNodeData Name="spriteTurnPos2" ActionTag="1367852427" Tag="3247" IconVisible="False" PositionPercentXEnabled="True" LeftMargin="8.0000" RightMargin="8.0000" TopMargin="6.3461" BottomMargin="84.6539" ctype="SpriteObjectData">
                <Size X="126.0000" Y="51.0000" />
                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                <Position X="71.0000" Y="110.1539" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition X="0.5000" Y="0.7757" />
                <PreSize X="0.8873" Y="0.3592" />
                <FileData Type="MarkedSubImage" Path="Image/IRoom/RoomCenter/CenterDirectTo.png" Plist="Texture/IRoom/RoomCenter.plist" />
                <BlendFunc Src="1" Dst="771" />
              </AbstractNodeData>
              <AbstractNodeData Name="spriteTurnPos3" ActionTag="-286298367" Tag="3248" RotationSkewX="-90.0000" RotationSkewY="-90.0000" IconVisible="False" PositionPercentYEnabled="True" LeftMargin="-33.0781" RightMargin="49.0781" TopMargin="45.5000" BottomMargin="45.5000" ctype="SpriteObjectData">
                <Size X="126.0000" Y="51.0000" />
                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                <Position X="29.9219" Y="71.0000" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition X="0.2107" Y="0.5000" />
                <PreSize X="0.8873" Y="0.3592" />
                <FileData Type="MarkedSubImage" Path="Image/IRoom/RoomCenter/CenterDirectTo.png" Plist="Texture/IRoom/RoomCenter.plist" />
                <BlendFunc Src="1" Dst="771" />
              </AbstractNodeData>
              <AbstractNodeData Name="spriteTurnPos4" ActionTag="1304272277" Tag="3249" RotationSkewX="180.0000" RotationSkewY="180.0000" IconVisible="False" PositionPercentXEnabled="True" LeftMargin="8.0000" RightMargin="8.0000" TopMargin="86.3460" BottomMargin="4.6540" ctype="SpriteObjectData">
                <Size X="126.0000" Y="51.0000" />
                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                <Position X="71.0000" Y="30.1540" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition X="0.5000" Y="0.2124" />
                <PreSize X="0.8873" Y="0.3592" />
                <FileData Type="MarkedSubImage" Path="Image/IRoom/RoomCenter/CenterDirectTo.png" Plist="Texture/IRoom/RoomCenter.plist" />
                <BlendFunc Src="1" Dst="771" />
              </AbstractNodeData>
            </Children>
            <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
            <Position />
            <Scale ScaleX="1.0000" ScaleY="1.0000" />
            <CColor A="255" R="255" G="255" B="255" />
            <PrePosition />
            <PreSize X="0.0000" Y="0.0000" />
            <FileData Type="MarkedSubImage" Path="Image/IRoom/RoomCenter/CenterDirectBG.png" Plist="Texture/IRoom/RoomCenter.plist" />
            <BlendFunc Src="1" Dst="771" />
          </AbstractNodeData>
          <AbstractNodeData Name="layoutRoundState" ActionTag="1685695721" Tag="3557" IconVisible="False" PositionPercentXEnabled="True" PositionPercentYEnabled="True" LeftMargin="-50.0000" RightMargin="-50.0000" TopMargin="-50.0000" BottomMargin="-50.0000" ClipAble="False" BackColorAlpha="102" ColorAngle="90.0000" Scale9Width="1" Scale9Height="1" ctype="PanelObjectData">
            <Size X="100.0000" Y="100.0000" />
            <Children>
              <AbstractNodeData Name="imgBGRemainNum" ActionTag="2024180273" Tag="3558" IconVisible="False" PositionPercentXEnabled="True" PositionPercentYEnabled="True" LeftMargin="-171.5600" RightMargin="112.5600" TopMargin="23.0000" BottomMargin="23.0000" Scale9Enable="True" LeftEage="31" RightEage="31" TopEage="11" BottomEage="11" Scale9OriginX="31" Scale9OriginY="11" Scale9Width="97" Scale9Height="32" ctype="ImageViewObjectData">
                <Size X="159.0000" Y="54.0000" />
                <Children>
                  <AbstractNodeData Name="txtRemainTile" ActionTag="135315946" Tag="8664" IconVisible="False" PositionPercentXEnabled="True" PositionPercentYEnabled="True" LeftMargin="58.5000" RightMargin="58.5000" TopMargin="17.0000" BottomMargin="17.0000" CharWidth="14" CharHeight="20" LabelText="245" StartChar="." ctype="TextAtlasObjectData">
                    <Size X="42.0000" Y="20.0000" />
                    <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                    <Position X="79.5000" Y="27.0000" />
                    <Scale ScaleX="1.0000" ScaleY="1.0000" />
                    <CColor A="255" R="230" G="230" B="250" />
                    <PrePosition X="0.5000" Y="0.5000" />
                    <PreSize X="0.2642" Y="0.3704" />
                    <LabelAtlasFileImage_CNB Type="Normal" Path="fonts/WhiteNumbers.png" Plist="" />
                  </AbstractNodeData>
                </Children>
                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                <Position X="-92.0600" Y="50.0000" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition X="-0.9206" Y="0.5000" />
                <PreSize X="1.5900" Y="0.5400" />
                <FileData Type="MarkedSubImage" Path="Image/IRoom/RoomCenter/CenterBGRemainTile.png" Plist="Texture/IRoom/RoomCenter.plist" />
              </AbstractNodeData>
              <AbstractNodeData Name="txtCountDown" ActionTag="-244063464" Tag="3562" IconVisible="False" PositionPercentXEnabled="True" PositionPercentYEnabled="True" LeftMargin="31.0000" RightMargin="31.0000" TopMargin="37.0000" BottomMargin="37.0000" CharWidth="19" CharHeight="26" LabelText="20" StartChar="." ctype="TextAtlasObjectData">
                <Size X="38.0000" Y="26.0000" />
                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                <Position X="50.0000" Y="50.0000" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="230" G="230" B="250" />
                <PrePosition X="0.5000" Y="0.5000" />
                <PreSize X="0.3800" Y="0.2600" />
                <LabelAtlasFileImage_CNB Type="Normal" Path="fonts/CountDownNumbers.png" Plist="" />
              </AbstractNodeData>
              <AbstractNodeData Name="imgBGRound" ActionTag="169226888" Tag="3563" IconVisible="False" PositionPercentXEnabled="True" PositionPercentYEnabled="True" LeftMargin="113.7500" RightMargin="-172.7500" TopMargin="23.0000" BottomMargin="23.0000" Scale9Enable="True" LeftEage="31" RightEage="31" TopEage="11" BottomEage="11" Scale9OriginX="31" Scale9OriginY="11" Scale9Width="97" Scale9Height="32" ctype="ImageViewObjectData">
                <Size X="159.0000" Y="54.0000" />
                <Children>
                  <AbstractNodeData Name="txtRoundNum" ActionTag="-1487562145" Tag="8665" IconVisible="False" PositionPercentXEnabled="True" PositionPercentYEnabled="True" LeftMargin="58.5000" RightMargin="58.5000" TopMargin="17.0000" BottomMargin="17.0000" CharWidth="14" CharHeight="20" LabelText="1/5" StartChar="." ctype="TextAtlasObjectData">
                    <Size X="42.0000" Y="20.0000" />
                    <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                    <Position X="79.5000" Y="27.0000" />
                    <Scale ScaleX="1.0000" ScaleY="1.0000" />
                    <CColor A="255" R="230" G="230" B="250" />
                    <PrePosition X="0.5000" Y="0.5000" />
                    <PreSize X="0.2642" Y="0.3704" />
                    <LabelAtlasFileImage_CNB Type="Normal" Path="fonts/WhiteNumbers.png" Plist="" />
                  </AbstractNodeData>
                </Children>
                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                <Position X="193.2500" Y="50.0000" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition X="1.9325" Y="0.5000" />
                <PreSize X="1.5900" Y="0.5400" />
                <FileData Type="MarkedSubImage" Path="Image/IRoom/RoomCenter/CenterBGRoundIndex.png" Plist="Texture/IRoom/RoomCenter.plist" />
              </AbstractNodeData>
            </Children>
            <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
            <Position />
            <Scale ScaleX="1.0000" ScaleY="1.0000" />
            <CColor A="255" R="255" G="255" B="255" />
            <PrePosition />
            <PreSize X="0.0000" Y="0.0000" />
            <SingleColor A="255" R="150" G="200" B="255" />
            <FirstColor A="255" R="150" G="200" B="255" />
            <EndColor A="255" R="255" G="255" B="255" />
            <ColorVector ScaleY="1.0000" />
          </AbstractNodeData>
        </Children>
      </ObjectData>
    </Content>
  </Content>
</GameFile>