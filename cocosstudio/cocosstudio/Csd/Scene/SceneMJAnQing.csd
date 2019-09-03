<GameFile>
  <PropertyGroup Name="SceneMJAnQing" Type="Layer" ID="fe270a6b-d61b-4cef-8e52-4b76c8896127" Version="3.10.0.0" />
  <Content ctype="GameProjectContent">
    <Content>
      <Animation Duration="60" Speed="1.0000" ActivedAnimationName="run">
        <Timeline ActionTag="-1344402719" Property="Alpha">
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
        <Timeline ActionTag="1257144731" Property="Alpha">
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
        <Timeline ActionTag="-1093256149" Property="Alpha">
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
        <Timeline ActionTag="-870704167" Property="Alpha">
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
          <RenderColor A="255" R="85" G="107" B="47" />
        </AnimationInfo>
      </AnimationList>
      <ObjectData Name="Layer" Tag="309" ctype="GameLayerObjectData">
        <Size X="1280.0000" Y="720.0000" />
        <Children>
          <AbstractNodeData Name="mahjong_table" CanEdit="False" ActionTag="-324165580" Tag="310" IconVisible="False" PositionPercentXEnabled="True" PositionPercentYEnabled="True" ctype="SpriteObjectData">
            <Size X="1280.0000" Y="720.0000" />
            <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
            <Position X="640.0000" Y="360.0000" />
            <Scale ScaleX="1.0000" ScaleY="1.0000" />
            <CColor A="255" R="255" G="255" B="255" />
            <PrePosition X="0.5000" Y="0.5000" />
            <PreSize X="1.0000" Y="1.0000" />
            <FileData Type="Normal" Path="Image/BigImg/game_bg1.png" Plist="" />
            <BlendFunc Src="770" Dst="771" />
          </AbstractNodeData>
          <AbstractNodeData Name="Btn_ready" ActionTag="-1480801228" Tag="321" IconVisible="False" PositionPercentXEnabled="True" LeftMargin="548.3960" RightMargin="546.6040" TopMargin="486.2461" BottomMargin="167.7539" TouchEnable="True" FontSize="36" LeftEage="15" RightEage="15" TopEage="11" BottomEage="11" Scale9OriginX="15" Scale9OriginY="11" Scale9Width="155" Scale9Height="44" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="ButtonObjectData">
            <Size X="185.0000" Y="66.0000" />
            <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
            <Position X="640.8960" Y="200.7539" />
            <Scale ScaleX="1.0000" ScaleY="1.0000" />
            <CColor A="255" R="255" G="255" B="255" />
            <PrePosition X="0.5007" Y="0.2788" />
            <PreSize X="0.1445" Y="0.0917" />
            <TextColor A="255" R="255" G="255" B="255" />
            <NormalFileData Type="MarkedSubImage" Path="Image/IRoom/CommomRoom/comm_btn_ready.png" Plist="Texture/IRoom/CommomRoom.plist" />
            <OutlineColor A="255" R="255" G="0" B="0" />
            <ShadowColor A="255" R="110" G="110" B="110" />
          </AbstractNodeData>
          <AbstractNodeData Name="btnCancelTuoGuan" ActionTag="1714118460" Tag="11889" IconVisible="False" PositionPercentXEnabled="True" LeftMargin="573.6760" RightMargin="569.3240" TopMargin="531.6694" BottomMargin="143.3306" TouchEnable="True" FontSize="36" LeftEage="15" RightEage="15" TopEage="11" BottomEage="11" Scale9OriginX="15" Scale9OriginY="11" Scale9Width="107" Scale9Height="23" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="ButtonObjectData">
            <Size X="137.0000" Y="45.0000" />
            <Children>
              <AbstractNodeData Name="txtTuoGuanDesc" ActionTag="462584242" Tag="958" IconVisible="False" PositionPercentXEnabled="True" LeftMargin="144.5000" RightMargin="-307.5000" TopMargin="1.0667" BottomMargin="-6.0667" IsCustomSize="True" FontSize="17" LabelText="托管期间系统不会自动执行摸牌，打牌，胡牌和暗杠以外的任何操作" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                <Size X="300.0000" Y="50.0000" />
                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                <Position X="294.5000" Y="18.9333" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="165" B="0" />
                <PrePosition X="2.1496" Y="0.4207" />
                <PreSize X="2.1898" Y="1.1111" />
                <OutlineColor A="255" R="255" G="0" B="0" />
                <ShadowColor A="255" R="110" G="110" B="110" />
              </AbstractNodeData>
              <AbstractNodeData Name="game_flag_tuoguan_1" ActionTag="-1778684507" Tag="11890" IconVisible="False" PositionPercentXEnabled="True" LeftMargin="14.0015" RightMargin="-16.0015" TopMargin="47.4999" BottomMargin="-47.4999" ctype="SpriteObjectData">
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
            <Position X="642.1760" Y="165.8306" />
            <Scale ScaleX="1.0000" ScaleY="1.0000" />
            <CColor A="255" R="255" G="255" B="255" />
            <PrePosition X="0.5017" Y="0.2303" />
            <PreSize X="0.1070" Y="0.0625" />
            <TextColor A="255" R="255" G="255" B="255" />
            <NormalFileData Type="MarkedSubImage" Path="Image/IRoom/CommomRoom/game_btn_qxtg.png" Plist="Texture/IRoom/CommomRoom.plist" />
            <OutlineColor A="255" R="255" G="0" B="0" />
            <ShadowColor A="255" R="110" G="110" B="110" />
          </AbstractNodeData>
          <AbstractNodeData Name="nodeTopBar" ActionTag="1920063134" Tag="7838" IconVisible="True" PositionPercentXEnabled="True" PositionPercentYEnabled="True" LeftMargin="640.0000" RightMargin="640.0000" BottomMargin="720.0000" StretchWidthEnable="False" StretchHeightEnable="False" InnerActionSpeed="1.0000" CustomSizeEnabled="False" ctype="ProjectNodeObjectData">
            <Size X="0.0000" Y="0.0000" />
            <AnchorPoint />
            <Position X="640.0000" Y="720.0000" />
            <Scale ScaleX="1.0000" ScaleY="1.0000" />
            <CColor A="255" R="255" G="255" B="255" />
            <PrePosition X="0.5000" Y="1.0000" />
            <PreSize X="0.0000" Y="0.0000" />
            <FileData Type="Normal" Path="Csd/IRoom/RoomComm/NodeTopBarNew.csd" Plist="" />
          </AbstractNodeData>
          <AbstractNodeData Name="Spr_turnPosBg" ActionTag="639843303" Tag="39" IconVisible="False" PositionPercentXEnabled="True" PositionPercentYEnabled="True" LeftMargin="569.0000" RightMargin="569.0000" TopMargin="289.0000" BottomMargin="289.0000" ctype="SpriteObjectData">
            <Size X="142.0000" Y="142.0000" />
            <Children>
              <AbstractNodeData Name="Spr_turnPos_1" ActionTag="-1344402719" Tag="40" RotationSkewX="90.0000" RotationSkewY="90.0000" IconVisible="False" LeftMargin="70.2301" RightMargin="-24.2301" TopMargin="47.0000" BottomMargin="49.0000" ctype="SpriteObjectData">
                <Size X="96.0000" Y="46.0000" />
                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                <Position X="118.2301" Y="72.0000" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition X="0.8326" Y="0.5070" />
                <PreSize X="0.6761" Y="0.3239" />
                <FileData Type="MarkedSubImage" Path="Image/IRoom/CommomRoom/game_direct_to.png" Plist="Texture/IRoom/CommomRoom.plist" />
                <BlendFunc Src="1" Dst="771" />
              </AbstractNodeData>
              <AbstractNodeData Name="Spr_turnPos_2" ActionTag="1257144731" Tag="41" IconVisible="False" LeftMargin="22.9999" RightMargin="23.0001" TopMargin="1.8463" BottomMargin="94.1537" ctype="SpriteObjectData">
                <Size X="96.0000" Y="46.0000" />
                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                <Position X="70.9999" Y="117.1537" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition X="0.5000" Y="0.8250" />
                <PreSize X="0.6761" Y="0.3239" />
                <FileData Type="MarkedSubImage" Path="Image/IRoom/CommomRoom/game_direct_to.png" Plist="Texture/IRoom/CommomRoom.plist" />
                <BlendFunc Src="1" Dst="771" />
              </AbstractNodeData>
              <AbstractNodeData Name="Spr_turnPos_3" ActionTag="-1093256149" Tag="42" RotationSkewX="-90.0000" RotationSkewY="-90.0000" IconVisible="False" LeftMargin="-23.0779" RightMargin="69.0779" TopMargin="49.0003" BottomMargin="46.9997" ctype="SpriteObjectData">
                <Size X="96.0000" Y="46.0000" />
                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                <Position X="24.9221" Y="69.9997" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition X="0.1755" Y="0.4930" />
                <PreSize X="0.6761" Y="0.3239" />
                <FileData Type="MarkedSubImage" Path="Image/IRoom/CommomRoom/game_direct_to.png" Plist="Texture/IRoom/CommomRoom.plist" />
                <BlendFunc Src="1" Dst="771" />
              </AbstractNodeData>
              <AbstractNodeData Name="Spr_turnPos_4" ActionTag="-870704167" Tag="43" RotationSkewX="180.0000" RotationSkewY="180.0000" IconVisible="False" LeftMargin="23.8452" RightMargin="22.1548" TopMargin="93.8462" BottomMargin="2.1538" ctype="SpriteObjectData">
                <Size X="96.0000" Y="46.0000" />
                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                <Position X="71.8452" Y="25.1538" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition X="0.5060" Y="0.1771" />
                <PreSize X="0.6761" Y="0.3239" />
                <FileData Type="MarkedSubImage" Path="Image/IRoom/CommomRoom/game_direct_to.png" Plist="Texture/IRoom/CommomRoom.plist" />
                <BlendFunc Src="1" Dst="771" />
              </AbstractNodeData>
            </Children>
            <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
            <Position X="640.0000" Y="360.0000" />
            <Scale ScaleX="1.0000" ScaleY="1.0000" />
            <CColor A="255" R="255" G="255" B="255" />
            <PrePosition X="0.5000" Y="0.5000" />
            <PreSize X="0.1109" Y="0.1972" />
            <FileData Type="MarkedSubImage" Path="Image/IRoom/CommomRoom/game_direct.png" Plist="Texture/IRoom/CommomRoom.plist" />
            <BlendFunc Src="1" Dst="771" />
          </AbstractNodeData>
          <AbstractNodeData Name="Node_readySign" ActionTag="-1104690038" Tag="412" IconVisible="True" PositionPercentXEnabled="True" PositionPercentYEnabled="True" LeftMargin="640.0000" RightMargin="640.0000" TopMargin="360.0000" BottomMargin="360.0000" ctype="SingleNodeObjectData">
            <Size X="0.0000" Y="0.0000" />
            <Children>
              <AbstractNodeData Name="Spr_readySign_1" ActionTag="58324643" Tag="340" IconVisible="False" LeftMargin="194.2016" RightMargin="-234.2016" TopMargin="-19.6905" BottomMargin="-24.3095" ctype="SpriteObjectData">
                <Size X="40.0000" Y="44.0000" />
                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                <Position X="214.2016" Y="-2.3095" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition />
                <PreSize X="0.0000" Y="0.0000" />
                <FileData Type="MarkedSubImage" Path="Image/IRoom/CommomRoom/game_ready.png" Plist="Texture/IRoom/CommomRoom.plist" />
                <BlendFunc Src="1" Dst="771" />
              </AbstractNodeData>
              <AbstractNodeData Name="Spr_readySign_2" ActionTag="-814763704" Tag="334" IconVisible="False" LeftMargin="-21.8011" RightMargin="-18.1989" TopMargin="-175.6916" BottomMargin="131.6916" ctype="SpriteObjectData">
                <Size X="40.0000" Y="44.0000" />
                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                <Position X="-1.8011" Y="153.6916" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition />
                <PreSize X="0.0000" Y="0.0000" />
                <FileData Type="MarkedSubImage" Path="Image/IRoom/CommomRoom/game_ready.png" Plist="Texture/IRoom/CommomRoom.plist" />
                <BlendFunc Src="1" Dst="771" />
              </AbstractNodeData>
              <AbstractNodeData Name="Spr_readySign_3" ActionTag="-406163900" Tag="346" IconVisible="False" LeftMargin="-237.8002" RightMargin="197.8002" TopMargin="-19.6905" BottomMargin="-24.3095" ctype="SpriteObjectData">
                <Size X="40.0000" Y="44.0000" />
                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                <Position X="-217.8002" Y="-2.3095" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition />
                <PreSize X="0.0000" Y="0.0000" />
                <FileData Type="MarkedSubImage" Path="Image/IRoom/CommomRoom/game_ready.png" Plist="Texture/IRoom/CommomRoom.plist" />
                <BlendFunc Src="1" Dst="771" />
              </AbstractNodeData>
              <AbstractNodeData Name="Spr_readySign_4" ActionTag="361378904" Tag="352" IconVisible="False" LeftMargin="-21.8011" RightMargin="-18.1989" TopMargin="134.3116" BottomMargin="-178.3116" ctype="SpriteObjectData">
                <Size X="40.0000" Y="44.0000" />
                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                <Position X="-1.8011" Y="-156.3116" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition />
                <PreSize X="0.0000" Y="0.0000" />
                <FileData Type="MarkedSubImage" Path="Image/IRoom/CommomRoom/game_ready.png" Plist="Texture/IRoom/CommomRoom.plist" />
                <BlendFunc Src="1" Dst="771" />
              </AbstractNodeData>
            </Children>
            <AnchorPoint />
            <Position X="640.0000" Y="360.0000" />
            <Scale ScaleX="1.0000" ScaleY="1.0000" />
            <CColor A="255" R="255" G="255" B="255" />
            <PrePosition X="0.5000" Y="0.5000" />
            <PreSize X="0.0000" Y="0.0000" />
          </AbstractNodeData>
          <AbstractNodeData Name="Node_decisionBtn" Visible="False" ActionTag="611551252" Tag="1138" IconVisible="True" RightMargin="1280.0000" TopMargin="720.0000" ctype="SingleNodeObjectData">
            <Size X="0.0000" Y="0.0000" />
            <Children>
              <AbstractNodeData Name="Btn_decision_4" ActionTag="821090261" Tag="394" IconVisible="False" LeftMargin="253.6356" RightMargin="-363.6356" TopMargin="-237.6218" BottomMargin="144.6218" TouchEnable="True" FontSize="14" LeftEage="15" RightEage="15" TopEage="11" BottomEage="11" Scale9OriginX="15" Scale9OriginY="11" Scale9Width="80" Scale9Height="71" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="ButtonObjectData">
                <Size X="110.0000" Y="93.0000" />
                <Children>
                  <AbstractNodeData Name="spriteTileBG" ActionTag="681042198" Tag="395" IconVisible="False" LeftMargin="104.0012" RightMargin="-74.0012" TopMargin="-11.5002" BottomMargin="-14.4998" ctype="SpriteObjectData">
                    <Size X="80.0000" Y="119.0000" />
                    <Children>
                      <AbstractNodeData Name="Spr_mjTile" ActionTag="1848137537" Tag="571" IconVisible="False" PositionPercentXEnabled="True" PositionPercentYEnabled="True" ctype="SpriteObjectData">
                        <Size X="80.0000" Y="119.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="40.0000" Y="59.5000" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition X="0.5000" Y="0.5000" />
                        <PreSize X="1.0000" Y="1.0000" />
                        <FileData Type="MarkedSubImage" Path="Image/CardsMJNew/p4s1_1.png" Plist="Texture/CardsMJNew.plist" />
                        <BlendFunc Src="1" Dst="771" />
                      </AbstractNodeData>
                    </Children>
                    <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                    <Position X="144.0012" Y="45.0002" />
                    <Scale ScaleX="0.7500" ScaleY="0.7500" />
                    <CColor A="255" R="255" G="255" B="255" />
                    <PrePosition X="1.3091" Y="0.4839" />
                    <PreSize X="0.7273" Y="1.2796" />
                    <FileData Type="MarkedSubImage" Path="Image/CardsMJNew/p4s0_0.png" Plist="Texture/CardsMJNew.plist" />
                    <BlendFunc Src="1" Dst="771" />
                  </AbstractNodeData>
                </Children>
                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                <Position X="308.6356" Y="191.1218" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition />
                <PreSize X="0.0000" Y="0.0000" />
                <TextColor A="255" R="65" G="65" B="70" />
                <NormalFileData Type="MarkedSubImage" Path="Image/IRoom/DecisionBtn/dec_chi.png" Plist="Texture/IRoom/DecisionBtn.plist" />
                <OutlineColor A="255" R="255" G="0" B="0" />
                <ShadowColor A="255" R="110" G="110" B="110" />
              </AbstractNodeData>
              <AbstractNodeData Name="Btn_decision_3" ActionTag="44302421" Tag="3" IconVisible="False" LeftMargin="442.6339" RightMargin="-552.6339" TopMargin="-237.6218" BottomMargin="144.6218" TouchEnable="True" FontSize="14" LeftEage="15" RightEage="15" TopEage="11" BottomEage="11" Scale9OriginX="15" Scale9OriginY="11" Scale9Width="80" Scale9Height="71" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="ButtonObjectData">
                <Size X="110.0000" Y="93.0000" />
                <Children>
                  <AbstractNodeData Name="spriteTileBG" ActionTag="1403303687" Tag="1143" IconVisible="False" LeftMargin="98.0012" RightMargin="-68.0012" TopMargin="-11.5002" BottomMargin="-14.4998" ctype="SpriteObjectData">
                    <Size X="80.0000" Y="119.0000" />
                    <Children>
                      <AbstractNodeData Name="Spr_mjTile" ActionTag="-464903553" Tag="572" IconVisible="False" PositionPercentXEnabled="True" PositionPercentYEnabled="True" ctype="SpriteObjectData">
                        <Size X="80.0000" Y="119.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="40.0000" Y="59.5000" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition X="0.5000" Y="0.5000" />
                        <PreSize X="1.0000" Y="1.0000" />
                        <FileData Type="MarkedSubImage" Path="Image/CardsMJNew/p4s1_1.png" Plist="Texture/CardsMJNew.plist" />
                        <BlendFunc Src="1" Dst="771" />
                      </AbstractNodeData>
                    </Children>
                    <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                    <Position X="138.0012" Y="45.0002" />
                    <Scale ScaleX="0.7500" ScaleY="0.7500" />
                    <CColor A="255" R="255" G="255" B="255" />
                    <PrePosition X="1.2546" Y="0.4839" />
                    <PreSize X="0.7273" Y="1.2796" />
                    <FileData Type="MarkedSubImage" Path="Image/CardsMJNew/p4s0_0.png" Plist="Texture/CardsMJNew.plist" />
                    <BlendFunc Src="1" Dst="771" />
                  </AbstractNodeData>
                </Children>
                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                <Position X="497.6339" Y="191.1218" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition />
                <PreSize X="0.0000" Y="0.0000" />
                <TextColor A="255" R="65" G="65" B="70" />
                <NormalFileData Type="MarkedSubImage" Path="Image/IRoom/DecisionBtn/dec_peng.png" Plist="Texture/IRoom/DecisionBtn.plist" />
                <OutlineColor A="255" R="255" G="0" B="0" />
                <ShadowColor A="255" R="110" G="110" B="110" />
              </AbstractNodeData>
              <AbstractNodeData Name="Btn_decision_2" ActionTag="382971586" Tag="2" IconVisible="False" LeftMargin="622.6921" RightMargin="-732.6921" TopMargin="-237.6218" BottomMargin="144.6218" TouchEnable="True" FontSize="14" LeftEage="15" RightEage="15" TopEage="11" BottomEage="11" Scale9OriginX="15" Scale9OriginY="11" Scale9Width="80" Scale9Height="71" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="ButtonObjectData">
                <Size X="110.0000" Y="93.0000" />
                <Children>
                  <AbstractNodeData Name="spriteTileBG" ActionTag="-170182977" Tag="1144" IconVisible="False" LeftMargin="103.0017" RightMargin="-73.0017" TopMargin="-11.5002" BottomMargin="-14.4998" ctype="SpriteObjectData">
                    <Size X="80.0000" Y="119.0000" />
                    <Children>
                      <AbstractNodeData Name="Spr_mjTile" ActionTag="131920404" Tag="573" IconVisible="False" PositionPercentXEnabled="True" PositionPercentYEnabled="True" ctype="SpriteObjectData">
                        <Size X="80.0000" Y="119.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="40.0000" Y="59.5000" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition X="0.5000" Y="0.5000" />
                        <PreSize X="1.0000" Y="1.0000" />
                        <FileData Type="MarkedSubImage" Path="Image/CardsMJNew/p4s1_1.png" Plist="Texture/CardsMJNew.plist" />
                        <BlendFunc Src="1" Dst="771" />
                      </AbstractNodeData>
                    </Children>
                    <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                    <Position X="143.0017" Y="45.0002" />
                    <Scale ScaleX="0.7500" ScaleY="0.7500" />
                    <CColor A="255" R="255" G="255" B="255" />
                    <PrePosition X="1.3000" Y="0.4839" />
                    <PreSize X="0.7273" Y="1.2796" />
                    <FileData Type="MarkedSubImage" Path="Image/CardsMJNew/p4s0_0.png" Plist="Texture/CardsMJNew.plist" />
                    <BlendFunc Src="1" Dst="771" />
                  </AbstractNodeData>
                </Children>
                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                <Position X="677.6921" Y="191.1218" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition />
                <PreSize X="0.0000" Y="0.0000" />
                <TextColor A="255" R="65" G="65" B="70" />
                <NormalFileData Type="MarkedSubImage" Path="Image/IRoom/DecisionBtn/dec_gang.png" Plist="Texture/IRoom/DecisionBtn.plist" />
                <OutlineColor A="255" R="255" G="0" B="0" />
                <ShadowColor A="255" R="110" G="110" B="110" />
              </AbstractNodeData>
              <AbstractNodeData Name="Btn_decision_1" ActionTag="996435278" Tag="1" IconVisible="False" LeftMargin="804.6652" RightMargin="-914.6652" TopMargin="-237.6218" BottomMargin="144.6218" TouchEnable="True" FontSize="14" LeftEage="15" RightEage="15" TopEage="11" BottomEage="11" Scale9OriginX="15" Scale9OriginY="11" Scale9Width="80" Scale9Height="71" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="ButtonObjectData">
                <Size X="110.0000" Y="93.0000" />
                <Children>
                  <AbstractNodeData Name="spriteTileBG" ActionTag="26972980" Tag="1145" IconVisible="False" LeftMargin="99.0020" RightMargin="-69.0020" TopMargin="-11.5002" BottomMargin="-14.4998" ctype="SpriteObjectData">
                    <Size X="80.0000" Y="119.0000" />
                    <Children>
                      <AbstractNodeData Name="Spr_mjTile" ActionTag="1627327046" Tag="570" IconVisible="False" PositionPercentXEnabled="True" PositionPercentYEnabled="True" ctype="SpriteObjectData">
                        <Size X="80.0000" Y="119.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="40.0000" Y="59.5000" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition X="0.5000" Y="0.5000" />
                        <PreSize X="1.0000" Y="1.0000" />
                        <FileData Type="MarkedSubImage" Path="Image/CardsMJNew/p4s1_1.png" Plist="Texture/CardsMJNew.plist" />
                        <BlendFunc Src="1" Dst="771" />
                      </AbstractNodeData>
                    </Children>
                    <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                    <Position X="139.0020" Y="45.0002" />
                    <Scale ScaleX="0.7500" ScaleY="0.7500" />
                    <CColor A="255" R="255" G="255" B="255" />
                    <PrePosition X="1.2637" Y="0.4839" />
                    <PreSize X="0.7273" Y="1.2796" />
                    <FileData Type="MarkedSubImage" Path="Image/CardsMJNew/p4s0_0.png" Plist="Texture/CardsMJNew.plist" />
                    <BlendFunc Src="1" Dst="771" />
                  </AbstractNodeData>
                </Children>
                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                <Position X="859.6652" Y="191.1218" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition />
                <PreSize X="0.0000" Y="0.0000" />
                <TextColor A="255" R="65" G="65" B="70" />
                <NormalFileData Type="MarkedSubImage" Path="Image/IRoom/DecisionBtn/dec_hu.png" Plist="Texture/IRoom/DecisionBtn.plist" />
                <OutlineColor A="255" R="255" G="0" B="0" />
                <ShadowColor A="255" R="110" G="110" B="110" />
              </AbstractNodeData>
              <AbstractNodeData Name="Btn_decision_0" ActionTag="986669220" IconVisible="False" LeftMargin="999.2163" RightMargin="-1092.2163" TopMargin="-245.6367" BottomMargin="152.6367" TouchEnable="True" FontSize="14" LeftEage="15" RightEage="15" TopEage="11" BottomEage="11" Scale9OriginX="15" Scale9OriginY="11" Scale9Width="63" Scale9Height="71" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="ButtonObjectData">
                <Size X="93.0000" Y="93.0000" />
                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                <Position X="1045.7163" Y="199.1367" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition />
                <PreSize X="0.0000" Y="0.0000" />
                <TextColor A="255" R="65" G="65" B="70" />
                <NormalFileData Type="MarkedSubImage" Path="Image/IRoom/DecisionBtn/dec_guo.png" Plist="Texture/IRoom/DecisionBtn.plist" />
                <OutlineColor A="255" R="255" G="0" B="0" />
                <ShadowColor A="255" R="110" G="110" B="110" />
              </AbstractNodeData>
            </Children>
            <AnchorPoint />
            <Position />
            <Scale ScaleX="1.0000" ScaleY="1.0000" />
            <CColor A="255" R="255" G="255" B="255" />
            <PrePosition />
            <PreSize X="0.0000" Y="0.0000" />
          </AbstractNodeData>
          <AbstractNodeData Name="Node_selfDrawnDecision" Visible="False" ActionTag="382975701" Tag="104" IconVisible="True" RightMargin="1280.0000" TopMargin="720.0000" ctype="SingleNodeObjectData">
            <Size X="0.0000" Y="0.0000" />
            <Children>
              <AbstractNodeData Name="Btn_decisionBar" ActionTag="-1217693205" Tag="105" IconVisible="False" LeftMargin="456.5000" RightMargin="-547.5000" TopMargin="-257.5000" BottomMargin="172.5000" TouchEnable="True" FontSize="14" LeftEage="15" RightEage="15" TopEage="11" BottomEage="11" Scale9OriginX="15" Scale9OriginY="11" Scale9Width="80" Scale9Height="71" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="ButtonObjectData">
                <Size X="91.0000" Y="85.0000" />
                <Children>
                  <AbstractNodeData Name="spriteTileBG" ActionTag="1620804343" Tag="106" IconVisible="False" LeftMargin="84.9998" RightMargin="-73.9998" TopMargin="-19.5000" BottomMargin="-14.5000" ctype="SpriteObjectData">
                    <Size X="80.0000" Y="119.0000" />
                    <Children>
                      <AbstractNodeData Name="Spr_mjTile" ActionTag="925471619" Tag="574" IconVisible="False" PositionPercentXEnabled="True" PositionPercentYEnabled="True" ctype="SpriteObjectData">
                        <Size X="80.0000" Y="119.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                        <Position X="40.0000" Y="59.5000" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="255" G="255" B="255" />
                        <PrePosition X="0.5000" Y="0.5000" />
                        <PreSize X="1.0000" Y="1.0000" />
                        <FileData Type="MarkedSubImage" Path="Image/CardsMJNew/p4s1_1.png" Plist="Texture/CardsMJNew.plist" />
                        <BlendFunc Src="1" Dst="771" />
                      </AbstractNodeData>
                    </Children>
                    <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                    <Position X="124.9998" Y="45.0000" />
                    <Scale ScaleX="0.7500" ScaleY="0.7500" />
                    <CColor A="255" R="255" G="255" B="255" />
                    <PrePosition X="1.3736" Y="0.5294" />
                    <PreSize X="0.8791" Y="1.4000" />
                    <FileData Type="MarkedSubImage" Path="Image/CardsMJNew/p4s0_0.png" Plist="Texture/CardsMJNew.plist" />
                    <BlendFunc Src="1" Dst="771" />
                  </AbstractNodeData>
                </Children>
                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                <Position X="502.0000" Y="215.0000" />
                <Scale ScaleX="1.2000" ScaleY="1.2000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition />
                <PreSize X="0.0000" Y="0.0000" />
                <TextColor A="255" R="65" G="65" B="70" />
                <NormalFileData Type="MarkedSubImage" Path="Image/IRoom/DecisionBtn/dec_gang.png" Plist="Texture/IRoom/DecisionBtn.plist" />
                <OutlineColor A="255" R="255" G="0" B="0" />
                <ShadowColor A="255" R="110" G="110" B="110" />
              </AbstractNodeData>
              <AbstractNodeData Name="Btn_decisionWin" ActionTag="-920826636" Tag="107" IconVisible="False" LeftMargin="734.5000" RightMargin="-825.5000" TopMargin="-257.5000" BottomMargin="172.5000" TouchEnable="True" FontSize="14" LeftEage="15" RightEage="15" TopEage="11" BottomEage="11" Scale9OriginX="15" Scale9OriginY="11" Scale9Width="80" Scale9Height="71" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="ButtonObjectData">
                <Size X="91.0000" Y="85.0000" />
                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                <Position X="780.0000" Y="215.0000" />
                <Scale ScaleX="1.2000" ScaleY="1.2000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition />
                <PreSize X="0.0000" Y="0.0000" />
                <TextColor A="255" R="65" G="65" B="70" />
                <NormalFileData Type="MarkedSubImage" Path="Image/IRoom/DecisionBtn/dec_hu.png" Plist="Texture/IRoom/DecisionBtn.plist" />
                <OutlineColor A="255" R="255" G="0" B="0" />
                <ShadowColor A="255" R="110" G="110" B="110" />
              </AbstractNodeData>
              <AbstractNodeData Name="Btn_decisionPass" ActionTag="-1333328175" Tag="109" IconVisible="False" LeftMargin="977.5000" RightMargin="-1068.5000" TopMargin="-257.5000" BottomMargin="172.5000" TouchEnable="True" FontSize="14" LeftEage="15" RightEage="15" TopEage="11" BottomEage="11" Scale9OriginX="15" Scale9OriginY="11" Scale9Width="63" Scale9Height="71" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="ButtonObjectData">
                <Size X="91.0000" Y="85.0000" />
                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                <Position X="1023.0000" Y="215.0000" />
                <Scale ScaleX="1.2000" ScaleY="1.2000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition />
                <PreSize X="0.0000" Y="0.0000" />
                <TextColor A="255" R="65" G="65" B="70" />
                <NormalFileData Type="MarkedSubImage" Path="Image/IRoom/DecisionBtn/dec_guo.png" Plist="Texture/IRoom/DecisionBtn.plist" />
                <OutlineColor A="255" R="255" G="0" B="0" />
                <ShadowColor A="255" R="110" G="110" B="110" />
              </AbstractNodeData>
              <AbstractNodeData Name="Btn_decisionTing" ActionTag="126766515" Tag="351" IconVisible="False" LeftMargin="242.3445" RightMargin="-333.3445" TopMargin="-248.9676" BottomMargin="163.9676" TouchEnable="True" FontSize="14" LeftEage="15" RightEage="15" TopEage="11" BottomEage="11" Scale9OriginX="15" Scale9OriginY="11" Scale9Width="80" Scale9Height="71" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="ButtonObjectData">
                <Size X="91.0000" Y="85.0000" />
                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                <Position X="287.8445" Y="206.4676" />
                <Scale ScaleX="1.2000" ScaleY="1.2000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition />
                <PreSize X="0.0000" Y="0.0000" />
                <TextColor A="255" R="65" G="65" B="70" />
                <NormalFileData Type="MarkedSubImage" Path="Image/IRoom/DecisionBtn/dec_ting.png" Plist="Texture/IRoom/DecisionBtn.plist" />
                <OutlineColor A="255" R="255" G="0" B="0" />
                <ShadowColor A="255" R="110" G="110" B="110" />
              </AbstractNodeData>
            </Children>
            <AnchorPoint />
            <Position />
            <Scale ScaleX="1.0000" ScaleY="1.0000" />
            <CColor A="255" R="255" G="255" B="255" />
            <PrePosition />
            <PreSize X="0.0000" Y="0.0000" />
          </AbstractNodeData>
          <AbstractNodeData Name="Sprite_for_cshupaitype" ActionTag="-47999135" VisibleForFrame="False" Tag="426" IconVisible="False" LeftMargin="440.7852" RightMargin="793.2148" TopMargin="611.1273" BottomMargin="62.8727" ctype="SpriteObjectData">
            <Size X="46.0000" Y="46.0000" />
            <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
            <Position X="463.7852" Y="85.8727" />
            <Scale ScaleX="1.0000" ScaleY="1.0000" />
            <CColor A="255" R="255" G="255" B="255" />
            <PrePosition X="0.3623" Y="0.1193" />
            <PreSize X="0.0359" Y="0.0639" />
            <FileData Type="Default" Path="Default/Sprite.png" Plist="" />
            <BlendFunc Src="1" Dst="771" />
          </AbstractNodeData>
          <AbstractNodeData Name="Node_SameIP" ActionTag="-1182340085" Tag="1283" IconVisible="True" RightMargin="1280.0000" TopMargin="720.0000" ctype="SingleNodeObjectData">
            <Size X="0.0000" Y="0.0000" />
            <AnchorPoint />
            <Position />
            <Scale ScaleX="1.0000" ScaleY="1.0000" />
            <CColor A="255" R="255" G="255" B="255" />
            <PrePosition />
            <PreSize X="0.0000" Y="0.0000" />
          </AbstractNodeData>
          <AbstractNodeData Name="Node_playBtns" ActionTag="852703287" Tag="320" IconVisible="False" PositionPercentXEnabled="True" PositionPercentYEnabled="True" LeftMargin="540.0000" RightMargin="540.0000" TopMargin="260.0000" BottomMargin="260.0000" ClipAble="False" BackColorAlpha="102" ColorAngle="90.0000" Scale9Width="1" Scale9Height="1" ctype="PanelObjectData">
            <Size X="200.0000" Y="200.0000" />
            <Children>
              <AbstractNodeData Name="Voice_Btn" ActionTag="2062801948" Tag="210" IconVisible="False" PositionPercentXEnabled="True" PositionPercentYEnabled="True" LeftMargin="622.0800" RightMargin="-505.0800" TopMargin="202.9400" BottomMargin="-86.9400" TouchEnable="True" FontSize="14" Scale9Enable="True" LeftEage="15" RightEage="15" TopEage="6" BottomEage="6" Scale9OriginX="15" Scale9OriginY="6" Scale9Width="53" Scale9Height="72" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="ButtonObjectData">
                <Size X="83.0000" Y="84.0000" />
                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                <Position X="663.5800" Y="-44.9400" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition X="3.3179" Y="-0.2247" />
                <PreSize X="0.4150" Y="0.4200" />
                <TextColor A="255" R="65" G="65" B="70" />
                <DisabledFileData Type="MarkedSubImage" Path="Image/IRoom/UIVoice/voice_btn_play_down.png" Plist="Texture/IRoom/UIVoice.plist" />
                <PressedFileData Type="MarkedSubImage" Path="Image/IRoom/UIVoice/voice_btn_play_down.png" Plist="Texture/IRoom/UIVoice.plist" />
                <NormalFileData Type="MarkedSubImage" Path="Image/IRoom/UIVoice/voice_btn_play_up.png" Plist="Texture/IRoom/UIVoice.plist" />
                <OutlineColor A="255" R="255" G="0" B="0" />
                <ShadowColor A="255" R="110" G="110" B="110" />
              </AbstractNodeData>
              <AbstractNodeData Name="Btn_message" ActionTag="1939872121" Tag="207" IconVisible="False" PositionPercentXEnabled="True" PositionPercentYEnabled="True" LeftMargin="622.0800" RightMargin="-505.0800" TopMargin="92.8000" BottomMargin="23.2000" TouchEnable="True" FontSize="14" Scale9Enable="True" LeftEage="15" RightEage="15" TopEage="11" BottomEage="11" Scale9OriginX="15" Scale9OriginY="11" Scale9Width="53" Scale9Height="62" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="ButtonObjectData">
                <Size X="83.0000" Y="84.0000" />
                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                <Position X="663.5800" Y="65.2000" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition X="3.3179" Y="0.3260" />
                <PreSize X="0.4150" Y="0.4200" />
                <TextColor A="255" R="65" G="65" B="70" />
                <DisabledFileData Type="MarkedSubImage" Path="Image/IRoom/UIVoice/voice_message.png" Plist="Texture/IRoom/UIVoice.plist" />
                <PressedFileData Type="MarkedSubImage" Path="Image/IRoom/UIVoice/voice_message.png" Plist="Texture/IRoom/UIVoice.plist" />
                <NormalFileData Type="MarkedSubImage" Path="Image/IRoom/UIVoice/voice_message.png" Plist="Texture/IRoom/UIVoice.plist" />
                <OutlineColor A="255" R="255" G="0" B="0" />
                <ShadowColor A="255" R="110" G="110" B="110" />
              </AbstractNodeData>
            </Children>
            <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
            <Position X="640.0000" Y="360.0000" />
            <Scale ScaleX="1.0000" ScaleY="1.0000" />
            <CColor A="255" R="255" G="255" B="255" />
            <PrePosition X="0.5000" Y="0.5000" />
            <PreSize X="0.1563" Y="0.2778" />
            <SingleColor A="255" R="150" G="200" B="255" />
            <FirstColor A="255" R="150" G="200" B="255" />
            <EndColor A="255" R="255" G="255" B="255" />
            <ColorVector ScaleY="1.0000" />
          </AbstractNodeData>
          <AbstractNodeData Name="Node_roundState" ActionTag="1639268030" Tag="321" IconVisible="False" PositionPercentXEnabled="True" PositionPercentYEnabled="True" PercentWidthEnable="True" PercentHeightEnable="True" PercentWidthEnabled="True" PercentHeightEnabled="True" LeftMargin="539.9680" RightMargin="539.9680" TopMargin="259.9920" BottomMargin="259.9920" ClipAble="False" BackColorAlpha="102" ColorAngle="90.0000" Scale9Width="1" Scale9Height="1" ctype="PanelObjectData">
            <Size X="200.0640" Y="200.0160" />
            <Children>
              <AbstractNodeData Name="imgBGRemainNum" ActionTag="1026236499" Tag="1958" IconVisible="False" PositionPercentXEnabled="True" PositionPercentYEnabled="True" LeftMargin="-81.9108" RightMargin="185.9748" TopMargin="83.0080" BottomMargin="83.0080" Scale9Enable="True" LeftEage="31" RightEage="31" TopEage="11" BottomEage="11" Scale9OriginX="31" Scale9OriginY="11" Scale9Width="34" Scale9Height="12" ctype="ImageViewObjectData">
                <Size X="96.0000" Y="34.0000" />
                <Children>
                  <AbstractNodeData Name="Label_param_1" ActionTag="-875836462" Tag="450" IconVisible="False" PositionPercentXEnabled="True" PositionPercentYEnabled="True" LeftMargin="3.3520" RightMargin="70.6480" TopMargin="3.6566" BottomMargin="4.3434" FontSize="22" LabelText="剩" VerticalAlignmentType="VT_Center" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                    <Size X="22.0000" Y="26.0000" />
                    <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                    <Position X="14.3520" Y="17.3434" />
                    <Scale ScaleX="1.0000" ScaleY="1.0000" />
                    <CColor A="255" R="0" G="255" B="99" />
                    <PrePosition X="0.1495" Y="0.5101" />
                    <PreSize X="0.2292" Y="0.7647" />
                    <OutlineColor A="255" R="255" G="0" B="0" />
                    <ShadowColor A="255" R="110" G="110" B="110" />
                  </AbstractNodeData>
                  <AbstractNodeData Name="Label_remainTiles" ActionTag="-985995585" Tag="451" IconVisible="False" PositionPercentXEnabled="True" PositionPercentYEnabled="True" LeftMargin="27.9720" RightMargin="29.0280" TopMargin="3.2416" BottomMargin="3.7584" FontSize="23" LabelText="136" HorizontalAlignmentType="HT_Center" VerticalAlignmentType="VT_Center" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                    <Size X="39.0000" Y="27.0000" />
                    <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                    <Position X="47.4720" Y="17.2584" />
                    <Scale ScaleX="1.0000" ScaleY="1.0000" />
                    <CColor A="255" R="255" G="214" B="0" />
                    <PrePosition X="0.4945" Y="0.5076" />
                    <PreSize X="0.4063" Y="0.7941" />
                    <OutlineColor A="255" R="255" G="0" B="0" />
                    <ShadowColor A="255" R="110" G="110" B="110" />
                  </AbstractNodeData>
                  <AbstractNodeData Name="Label_param_2" ActionTag="290237926" Tag="452" IconVisible="False" PositionPercentXEnabled="True" PositionPercentYEnabled="True" LeftMargin="71.9536" RightMargin="2.0464" TopMargin="3.6566" BottomMargin="4.3434" FontSize="22" LabelText="张" VerticalAlignmentType="VT_Center" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                    <Size X="22.0000" Y="26.0000" />
                    <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                    <Position X="82.9536" Y="17.3434" />
                    <Scale ScaleX="1.0000" ScaleY="1.0000" />
                    <CColor A="255" R="0" G="255" B="99" />
                    <PrePosition X="0.8641" Y="0.5101" />
                    <PreSize X="0.2292" Y="0.7647" />
                    <OutlineColor A="255" R="255" G="0" B="0" />
                    <ShadowColor A="255" R="110" G="110" B="110" />
                  </AbstractNodeData>
                </Children>
                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                <Position X="-33.9108" Y="100.0080" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition X="-0.1695" Y="0.5000" />
                <PreSize X="0.4798" Y="0.1700" />
                <FileData Type="MarkedSubImage" Path="Image/IRoom/CommomRoom/game_comm_bg_round.png" Plist="Texture/IRoom/CommomRoom.plist" />
              </AbstractNodeData>
              <AbstractNodeData Name="Label_playTimeCD" ActionTag="-172217181" Tag="293" IconVisible="False" PositionPercentXEnabled="True" PositionPercentYEnabled="True" LeftMargin="82.0320" RightMargin="82.0320" TopMargin="85.0080" BottomMargin="85.0080" CharWidth="18" CharHeight="30" LabelText="20" StartChar="0" ctype="TextAtlasObjectData">
                <Size X="36.0000" Y="30.0000" />
                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                <Position X="100.0320" Y="100.0080" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition X="0.5000" Y="0.5000" />
                <PreSize X="0.1799" Y="0.1500" />
                <LabelAtlasFileImage_CNB Type="Normal" Path="fonts/font_number_1.png" Plist="" />
              </AbstractNodeData>
              <AbstractNodeData Name="imgBGRound" ActionTag="1676977010" Tag="1959" IconVisible="False" PositionPercentXEnabled="True" PositionPercentYEnabled="True" LeftMargin="186.1149" RightMargin="-82.0509" TopMargin="83.0080" BottomMargin="83.0080" FlipX="True" Scale9Enable="True" LeftEage="31" RightEage="31" TopEage="11" BottomEage="11" Scale9OriginX="31" Scale9OriginY="11" Scale9Width="34" Scale9Height="12" ctype="ImageViewObjectData">
                <Size X="96.0000" Y="34.0000" />
                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                <Position X="234.1149" Y="100.0080" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition X="1.1702" Y="0.5000" />
                <PreSize X="0.4798" Y="0.1700" />
                <FileData Type="MarkedSubImage" Path="Image/IRoom/CommomRoom/game_comm_bg_round.png" Plist="Texture/IRoom/CommomRoom.plist" />
              </AbstractNodeData>
              <AbstractNodeData Name="Label_param_1_0" ActionTag="-117707893" Tag="1960" IconVisible="False" PositionPercentXEnabled="True" PositionPercentYEnabled="True" LeftMargin="187.6835" RightMargin="-9.6196" TopMargin="87.3080" BottomMargin="86.7080" FontSize="22" LabelText="第" VerticalAlignmentType="VT_Center" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                <Size X="22.0000" Y="26.0000" />
                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                <Position X="198.6835" Y="99.7080" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="0" G="255" B="99" />
                <PrePosition X="0.9931" Y="0.4985" />
                <PreSize X="0.1100" Y="0.1300" />
                <OutlineColor A="255" R="255" G="0" B="0" />
                <ShadowColor A="255" R="110" G="110" B="110" />
              </AbstractNodeData>
              <AbstractNodeData Name="txtRoundNum" ActionTag="-45815979" Tag="1961" IconVisible="False" PositionPercentXEnabled="True" PositionPercentYEnabled="True" LeftMargin="215.6941" RightMargin="-47.6301" TopMargin="86.3080" BottomMargin="86.7080" FontSize="23" LabelText="1/2" HorizontalAlignmentType="HT_Center" VerticalAlignmentType="VT_Center" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                <Size X="32.0000" Y="27.0000" />
                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                <Position X="231.6941" Y="100.2080" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="214" B="0" />
                <PrePosition X="1.1581" Y="0.5010" />
                <PreSize X="0.1599" Y="0.1350" />
                <OutlineColor A="255" R="255" G="0" B="0" />
                <ShadowColor A="255" R="110" G="110" B="110" />
              </AbstractNodeData>
              <AbstractNodeData Name="Label_param_2_0" ActionTag="2065264601" Tag="1962" IconVisible="False" PositionPercentXEnabled="True" PositionPercentYEnabled="True" LeftMargin="256.7056" RightMargin="-78.6416" TopMargin="86.3079" BottomMargin="87.7080" FontSize="22" LabelText="局" VerticalAlignmentType="VT_Center" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                <Size X="22.0000" Y="26.0000" />
                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                <Position X="267.7056" Y="100.7080" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="0" G="255" B="99" />
                <PrePosition X="1.3381" Y="0.5035" />
                <PreSize X="0.1100" Y="0.1300" />
                <OutlineColor A="255" R="255" G="0" B="0" />
                <ShadowColor A="255" R="110" G="110" B="110" />
              </AbstractNodeData>
            </Children>
            <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
            <Position X="640.0000" Y="360.0000" />
            <Scale ScaleX="1.0000" ScaleY="1.0000" />
            <CColor A="255" R="255" G="255" B="255" />
            <PrePosition X="0.5000" Y="0.5000" />
            <PreSize X="0.1563" Y="0.2778" />
            <SingleColor A="255" R="150" G="200" B="255" />
            <FirstColor A="255" R="150" G="200" B="255" />
            <EndColor A="255" R="255" G="255" B="255" />
            <ColorVector ScaleY="1.0000" />
          </AbstractNodeData>
          <AbstractNodeData Name="Node_readyPlay" Visible="False" ActionTag="-1737578660" Tag="324" IconVisible="False" PositionPercentXEnabled="True" PositionPercentYEnabled="True" PercentWidthEnable="True" PercentHeightEnable="True" PercentWidthEnabled="True" PercentHeightEnabled="True" ClipAble="False" BackColorAlpha="102" ColorAngle="90.0000" Scale9Width="1" Scale9Height="1" ctype="PanelObjectData">
            <Size X="1280.0000" Y="720.0000" />
            <Children>
              <AbstractNodeData Name="Btn_inviteFriend" ActionTag="-56590495" Tag="60" IconVisible="False" PositionPercentXEnabled="True" PositionPercentYEnabled="True" LeftMargin="485.0000" RightMargin="485.0000" TopMargin="322.5000" BottomMargin="322.5000" TouchEnable="True" FontSize="14" LeftEage="15" RightEage="15" TopEage="11" BottomEage="11" Scale9OriginX="15" Scale9OriginY="11" Scale9Width="280" Scale9Height="53" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="ButtonObjectData">
                <Size X="310.0000" Y="75.0000" />
                <Children>
                  <AbstractNodeData Name="btnCopyInviteFriend" ActionTag="1081861400" Tag="237" IconVisible="False" PositionPercentXEnabled="True" TopMargin="75.0000" BottomMargin="-75.0000" TouchEnable="True" FontSize="14" LeftEage="15" RightEage="15" TopEage="11" BottomEage="11" Scale9OriginX="15" Scale9OriginY="11" Scale9Width="280" Scale9Height="53" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="ButtonObjectData">
                    <Size X="310.0000" Y="75.0000" />
                    <AnchorPoint ScaleX="0.5000" ScaleY="1.0000" />
                    <Position X="155.0000" />
                    <Scale ScaleX="1.0000" ScaleY="1.0000" />
                    <CColor A="255" R="255" G="255" B="255" />
                    <PrePosition X="0.5000" />
                    <PreSize X="1.0000" Y="1.0000" />
                    <TextColor A="255" R="65" G="65" B="70" />
                    <NormalFileData Type="MarkedSubImage" Path="Image/IRoom/CommomRoom/game_btn_copy_roomID.png" Plist="Texture/IRoom/CommomRoom.plist" />
                    <OutlineColor A="255" R="255" G="0" B="0" />
                    <ShadowColor A="255" R="110" G="110" B="110" />
                  </AbstractNodeData>
                </Children>
                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                <Position X="640.0000" Y="360.0000" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition X="0.5000" Y="0.5000" />
                <PreSize X="0.2422" Y="0.1042" />
                <TextColor A="255" R="65" G="65" B="70" />
                <NormalFileData Type="MarkedSubImage" Path="Image/IRoom/CommomRoom/game_btn_invert.png" Plist="Texture/IRoom/CommomRoom.plist" />
                <OutlineColor A="255" R="255" G="0" B="0" />
                <ShadowColor A="255" R="110" G="110" B="110" />
              </AbstractNodeData>
            </Children>
            <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
            <Position X="640.0000" Y="360.0000" />
            <Scale ScaleX="1.0000" ScaleY="1.0000" />
            <CColor A="255" R="255" G="255" B="255" />
            <PrePosition X="0.5000" Y="0.5000" />
            <PreSize X="1.0000" Y="1.0000" />
            <SingleColor A="255" R="150" G="200" B="255" />
            <FirstColor A="255" R="150" G="200" B="255" />
            <EndColor A="255" R="255" G="255" B="255" />
            <ColorVector ScaleY="1.0000" />
          </AbstractNodeData>
          <AbstractNodeData Name="Node_playerInfo_1" ActionTag="-1689194318" Tag="193" IconVisible="True" PositionPercentXEnabled="True" PositionPercentYEnabled="True" LeftMargin="1204.9919" RightMargin="75.0081" TopMargin="270.0000" BottomMargin="450.0000" ctype="SingleNodeObjectData">
            <Size X="0.0000" Y="0.0000" />
            <Children>
              <AbstractNodeData Name="headallbk" ActionTag="759170168" Tag="194" IconVisible="False" LeftMargin="-24.7362" RightMargin="-21.2638" TopMargin="-49.6309" BottomMargin="3.6309" ctype="SpriteObjectData">
                <Size X="46.0000" Y="46.0000" />
                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                <Position X="-1.7362" Y="26.6309" />
                <Scale ScaleX="0.8200" ScaleY="0.8200" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition />
                <PreSize X="0.0000" Y="0.0000" />
                <FileData Type="Default" Path="Default/Sprite.png" Plist="" />
                <BlendFunc Src="770" Dst="1" />
              </AbstractNodeData>
              <AbstractNodeData Name="Spr_head" ActionTag="585522914" Tag="195" IconVisible="False" LeftMargin="-50.0000" RightMargin="-50.0000" TopMargin="-92.0000" BottomMargin="-8.0000" ctype="SpriteObjectData">
                <Size X="100.0000" Y="100.0000" />
                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                <Position Y="42.0000" />
                <Scale ScaleX="0.9000" ScaleY="0.9000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition />
                <PreSize X="0.0000" Y="0.0000" />
                <FileData Type="MarkedSubImage" Path="Image/GComm/comm_head_icon.png" Plist="Texture/GComm.plist" />
                <BlendFunc Src="1" Dst="771" />
              </AbstractNodeData>
              <AbstractNodeData Name="Btn_headFrame" ActionTag="-2135938981" Tag="196" IconVisible="False" LeftMargin="-54.6404" RightMargin="-54.3596" TopMargin="-92.5794" BottomMargin="-15.4206" TouchEnable="True" FontSize="14" LeftEage="15" RightEage="15" TopEage="11" BottomEage="11" Scale9OriginX="15" Scale9OriginY="11" Scale9Width="59" Scale9Height="67" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="ButtonObjectData">
                <Size X="109.0000" Y="108.0000" />
                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                <Position X="-0.1404" Y="38.5794" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition />
                <PreSize X="0.0000" Y="0.0000" />
                <TextColor A="255" R="65" G="65" B="70" />
                <PressedFileData Type="MarkedSubImage" Path="Image/GComm/comm_head_frame.png" Plist="Texture/GComm.plist" />
                <NormalFileData Type="MarkedSubImage" Path="Image/GComm/comm_head_frame.png" Plist="Texture/GComm.plist" />
                <OutlineColor A="255" R="255" G="0" B="0" />
                <ShadowColor A="255" R="110" G="110" B="110" />
              </AbstractNodeData>
              <AbstractNodeData Name="Label_nickname" ActionTag="-1824174301" Tag="197" IconVisible="False" LeftMargin="-34.3155" RightMargin="-37.6845" TopMargin="-120.3918" BottomMargin="92.3918" FontSize="24" LabelText="李晓明" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ShadowEnabled="True" ctype="TextObjectData">
                <Size X="72.0000" Y="28.0000" />
                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                <Position X="1.6845" Y="106.3918" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="250" G="180" B="110" />
                <PrePosition />
                <PreSize X="0.0000" Y="0.0000" />
                <FontResource Type="Default" Path="" Plist="" />
                <OutlineColor A="255" R="255" G="0" B="0" />
                <ShadowColor A="255" R="0" G="0" B="0" />
              </AbstractNodeData>
              <AbstractNodeData Name="Label_score" ActionTag="1546214286" Tag="198" IconVisible="False" LeftMargin="-29.2701" RightMargin="-24.7299" TopMargin="11.7381" BottomMargin="-39.7381" FontSize="24" LabelText="1000" OutlineEnabled="True" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ShadowEnabled="True" ctype="TextObjectData">
                <Size X="54.0000" Y="28.0000" />
                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                <Position X="-2.2701" Y="-25.7381" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition />
                <PreSize X="0.0000" Y="0.0000" />
                <OutlineColor A="255" R="0" G="0" B="0" />
                <ShadowColor A="255" R="26" G="26" B="26" />
              </AbstractNodeData>
              <AbstractNodeData Name="Spr_offLineSign" ActionTag="2003703552" Tag="199" IconVisible="False" LeftMargin="-58.2211" RightMargin="34.2211" TopMargin="-11.4362" BottomMargin="-12.5638" ctype="SpriteObjectData">
                <Size X="24.0000" Y="24.0000" />
                <AnchorPoint />
                <Position X="-58.2211" Y="-12.5638" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition />
                <PreSize X="0.0000" Y="0.0000" />
                <FileData Type="MarkedSubImage" Path="Image/IRoom/CommomRoom/game_icon_offline.png" Plist="Texture/IRoom/CommomRoom.plist" />
                <BlendFunc Src="1" Dst="771" />
              </AbstractNodeData>
              <AbstractNodeData Name="Spr_bankerSign" ActionTag="1832721593" Tag="200" IconVisible="False" LeftMargin="4.7918" RightMargin="-75.7918" TopMargin="-125.6726" BottomMargin="38.6726" ctype="SpriteObjectData">
                <Size X="71.0000" Y="87.0000" />
                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                <Position X="40.2918" Y="82.1726" />
                <Scale ScaleX="0.5000" ScaleY="0.5000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition />
                <PreSize X="0.0000" Y="0.0000" />
                <FileData Type="MarkedSubImage" Path="Image/IRoom/CommomRoom/game_icon_zhuang.png" Plist="Texture/IRoom/CommomRoom.plist" />
                <BlendFunc Src="1" Dst="771" />
              </AbstractNodeData>
              <AbstractNodeData Name="Spr_tingSign" ActionTag="-873701581" Tag="3377" IconVisible="False" LeftMargin="-81.3412" RightMargin="10.3412" TopMargin="-126.1507" BottomMargin="39.1507" ctype="SpriteObjectData">
                <Size X="71.0000" Y="87.0000" />
                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                <Position X="-45.8412" Y="82.6507" />
                <Scale ScaleX="0.5000" ScaleY="0.5000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition />
                <PreSize X="0.0000" Y="0.0000" />
                <FileData Type="MarkedSubImage" Path="Image/IRoom/CommomRoom/game_icon_ting.png" Plist="Texture/IRoom/CommomRoom.plist" />
                <BlendFunc Src="1" Dst="771" />
              </AbstractNodeData>
              <AbstractNodeData Name="Spr_fangzhuSign" ActionTag="-991033569" Tag="1358" IconVisible="False" LeftMargin="14.9127" RightMargin="-58.9127" TopMargin="-33.4934" BottomMargin="-10.5066" ctype="SpriteObjectData">
                <Size X="44.0000" Y="44.0000" />
                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                <Position X="36.9127" Y="11.4934" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition />
                <PreSize X="0.0000" Y="0.0000" />
                <FileData Type="MarkedSubImage" Path="Image/IRoom/CommomRoom/game_icon_fang.png" Plist="Texture/IRoom/CommomRoom.plist" />
                <BlendFunc Src="1" Dst="771" />
              </AbstractNodeData>
              <AbstractNodeData Name="Img_playerChatBg_1" Visible="False" ActionTag="-819264841" Tag="827" IconVisible="False" LeftMargin="-523.9108" RightMargin="55.9108" TopMargin="-65.0938" BottomMargin="7.0938" Scale9Enable="True" LeftEage="40" RightEage="40" Scale9OriginX="40" Scale9Width="20" Scale9Height="58" ctype="ImageViewObjectData">
                <Size X="468.0000" Y="58.0000" />
                <Children>
                  <AbstractNodeData Name="Label_msg" ActionTag="-887137284" Tag="970" IconVisible="False" LeftMargin="15.9993" RightMargin="68.0007" TopMargin="14.5003" BottomMargin="6.4997" FontSize="32" LabelText="快点啊，我等到花儿也谢了" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                    <Size X="384.0000" Y="37.0000" />
                    <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                    <Position X="207.9993" Y="24.9997" />
                    <Scale ScaleX="1.0000" ScaleY="1.0000" />
                    <CColor A="255" R="107" G="64" B="47" />
                    <PrePosition X="0.4444" Y="0.4310" />
                    <PreSize X="0.8205" Y="0.6379" />
                    <OutlineColor A="255" R="255" G="0" B="0" />
                    <ShadowColor A="255" R="110" G="110" B="110" />
                  </AbstractNodeData>
                </Children>
                <AnchorPoint ScaleX="1.0000" ScaleY="0.5000" />
                <Position X="-55.9108" Y="36.0938" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition />
                <PreSize X="0.0000" Y="0.0000" />
                <FileData Type="MarkedSubImage" Path="Image/IRoom/UIChat/chat_bg_up.png" Plist="Texture/IRoom/UIChat.plist" />
              </AbstractNodeData>
              <AbstractNodeData Name="Node_1" ActionTag="1432333672" Tag="713" IconVisible="True" LeftMargin="-88.6975" RightMargin="88.6975" TopMargin="-53.1049" BottomMargin="53.1049" ctype="SingleNodeObjectData">
                <Size X="0.0000" Y="0.0000" />
                <AnchorPoint />
                <Position X="-88.6975" Y="53.1049" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition />
                <PreSize X="0.0000" Y="0.0000" />
              </AbstractNodeData>
              <AbstractNodeData Name="Spr_emoji1" ActionTag="-1153982881" Tag="1451" IconVisible="True" LeftMargin="-1.9523" RightMargin="1.9523" TopMargin="70.2725" BottomMargin="-70.2725" ctype="SingleNodeObjectData">
                <Size X="0.0000" Y="0.0000" />
                <AnchorPoint />
                <Position X="-1.9523" Y="-70.2725" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition />
                <PreSize X="0.0000" Y="0.0000" />
              </AbstractNodeData>
              <AbstractNodeData Name="txtZuoLaPao" ActionTag="2013174303" Tag="4156" IconVisible="False" LeftMargin="-43.7798" RightMargin="-48.2202" TopMargin="33.9305" BottomMargin="-62.9305" FontSize="25" LabelText="蹲4炮40" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                <Size X="92.0000" Y="29.0000" />
                <AnchorPoint ScaleX="1.0000" ScaleY="0.5000" />
                <Position X="48.2202" Y="-48.4305" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="0" />
                <PrePosition />
                <PreSize X="0.0000" Y="0.0000" />
                <OutlineColor A="255" R="255" G="0" B="0" />
                <ShadowColor A="255" R="110" G="110" B="110" />
              </AbstractNodeData>
              <AbstractNodeData Name="iconTuoGuanFlag" ActionTag="-785896432" Tag="11894" IconVisible="False" LeftMargin="-46.9443" RightMargin="-45.0557" TopMargin="-88.6379" BottomMargin="-3.3621" ctype="SpriteObjectData">
                <Size X="92.0000" Y="92.0000" />
                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                <Position X="-0.9443" Y="42.6379" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition />
                <PreSize X="0.0000" Y="0.0000" />
                <FileData Type="MarkedSubImage" Path="Image/IRoom/CommomRoom/game_icon_tuoguan.png" Plist="Texture/IRoom/CommomRoom.plist" />
                <BlendFunc Src="1" Dst="771" />
              </AbstractNodeData>
            </Children>
            <AnchorPoint />
            <Position X="1204.9919" Y="450.0000" />
            <Scale ScaleX="1.0000" ScaleY="1.0000" />
            <CColor A="255" R="255" G="255" B="255" />
            <PrePosition X="0.9414" Y="0.6250" />
            <PreSize X="0.0000" Y="0.0000" />
          </AbstractNodeData>
          <AbstractNodeData Name="Node_playerInfo_2" ActionTag="-2055577291" Tag="201" IconVisible="True" PositionPercentXEnabled="True" PositionPercentYEnabled="True" LeftMargin="640.0000" RightMargin="640.0000" TopMargin="2.8800" BottomMargin="717.1200" ctype="SingleNodeObjectData">
            <Size X="0.0000" Y="0.0000" />
            <Children>
              <AbstractNodeData Name="headallbk" ActionTag="2097260273" Tag="202" IconVisible="False" LeftMargin="305.3860" RightMargin="-351.3860" TopMargin="151.0212" BottomMargin="-197.0212" ctype="SpriteObjectData">
                <Size X="46.0000" Y="46.0000" />
                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                <Position X="328.3860" Y="-174.0212" />
                <Scale ScaleX="0.8200" ScaleY="0.8200" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition />
                <PreSize X="0.0000" Y="0.0000" />
                <FileData Type="Default" Path="Default/Sprite.png" Plist="" />
                <BlendFunc Src="770" Dst="1" />
              </AbstractNodeData>
              <AbstractNodeData Name="Spr_head" ActionTag="1598206666" Tag="203" IconVisible="False" LeftMargin="278.3854" RightMargin="-378.3854" TopMargin="108.6544" BottomMargin="-208.6544" ctype="SpriteObjectData">
                <Size X="100.0000" Y="100.0000" />
                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                <Position X="328.3854" Y="-158.6544" />
                <Scale ScaleX="0.9000" ScaleY="0.9000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition />
                <PreSize X="0.0000" Y="0.0000" />
                <FileData Type="MarkedSubImage" Path="Image/GComm/comm_head_icon.png" Plist="Texture/GComm.plist" />
                <BlendFunc Src="1" Dst="771" />
              </AbstractNodeData>
              <AbstractNodeData Name="Btn_headFrame" ActionTag="-577877898" Tag="204" IconVisible="False" LeftMargin="273.8852" RightMargin="-382.8852" TopMargin="107.6558" BottomMargin="-215.6558" TouchEnable="True" FontSize="14" LeftEage="15" RightEage="15" TopEage="11" BottomEage="11" Scale9OriginX="15" Scale9OriginY="11" Scale9Width="59" Scale9Height="67" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="ButtonObjectData">
                <Size X="109.0000" Y="108.0000" />
                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                <Position X="328.3852" Y="-161.6558" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition />
                <PreSize X="0.0000" Y="0.0000" />
                <TextColor A="255" R="65" G="65" B="70" />
                <PressedFileData Type="MarkedSubImage" Path="Image/GComm/comm_head_frame.png" Plist="Texture/GComm.plist" />
                <NormalFileData Type="MarkedSubImage" Path="Image/GComm/comm_head_frame.png" Plist="Texture/GComm.plist" />
                <OutlineColor A="255" R="255" G="0" B="0" />
                <ShadowColor A="255" R="110" G="110" B="110" />
              </AbstractNodeData>
              <AbstractNodeData Name="Label_nickname" ActionTag="-1078340727" Tag="205" IconVisible="False" LeftMargin="292.3875" RightMargin="-364.3875" TopMargin="80.2639" BottomMargin="-108.2639" FontSize="24" LabelText="李晓明" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ShadowEnabled="True" ctype="TextObjectData">
                <Size X="72.0000" Y="28.0000" />
                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                <Position X="328.3875" Y="-94.2639" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="250" G="180" B="110" />
                <PrePosition />
                <PreSize X="0.0000" Y="0.0000" />
                <FontResource Type="Default" Path="" Plist="" />
                <OutlineColor A="255" R="255" G="0" B="0" />
                <ShadowColor A="255" R="0" G="0" B="0" />
              </AbstractNodeData>
              <AbstractNodeData Name="Label_score" ActionTag="1794291746" Tag="206" IconVisible="False" LeftMargin="301.3869" RightMargin="-355.3869" TopMargin="212.3914" BottomMargin="-240.3914" FontSize="24" LabelText="1000" OutlineEnabled="True" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ShadowEnabled="True" ctype="TextObjectData">
                <Size X="54.0000" Y="28.0000" />
                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                <Position X="328.3869" Y="-226.3914" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition />
                <PreSize X="0.0000" Y="0.0000" />
                <OutlineColor A="255" R="0" G="0" B="0" />
                <ShadowColor A="255" R="26" G="26" B="26" />
              </AbstractNodeData>
              <AbstractNodeData Name="Spr_offLineSign" ActionTag="2140496461" Tag="207" IconVisible="False" LeftMargin="270.0408" RightMargin="-294.0408" TopMargin="188.2170" BottomMargin="-212.2170" ctype="SpriteObjectData">
                <Size X="24.0000" Y="24.0000" />
                <AnchorPoint />
                <Position X="270.0408" Y="-212.2170" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition />
                <PreSize X="0.0000" Y="0.0000" />
                <FileData Type="MarkedSubImage" Path="Image/IRoom/CommomRoom/game_icon_offline.png" Plist="Texture/IRoom/CommomRoom.plist" />
                <BlendFunc Src="1" Dst="771" />
              </AbstractNodeData>
              <AbstractNodeData Name="Spr_bankerSign" ActionTag="-1603925152" Tag="208" IconVisible="False" LeftMargin="334.6646" RightMargin="-405.6646" TopMargin="72.1234" BottomMargin="-159.1234" ctype="SpriteObjectData">
                <Size X="71.0000" Y="87.0000" />
                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                <Position X="370.1646" Y="-115.6234" />
                <Scale ScaleX="0.5000" ScaleY="0.5000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition />
                <PreSize X="0.0000" Y="0.0000" />
                <FileData Type="MarkedSubImage" Path="Image/IRoom/CommomRoom/game_icon_zhuang.png" Plist="Texture/IRoom/CommomRoom.plist" />
                <BlendFunc Src="1" Dst="771" />
              </AbstractNodeData>
              <AbstractNodeData Name="Spr_tingSign" ActionTag="888299570" Tag="3376" IconVisible="False" LeftMargin="245.4296" RightMargin="-316.4296" TopMargin="68.1916" BottomMargin="-155.1916" ctype="SpriteObjectData">
                <Size X="71.0000" Y="87.0000" />
                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                <Position X="280.9296" Y="-111.6916" />
                <Scale ScaleX="0.5000" ScaleY="0.5000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition />
                <PreSize X="0.0000" Y="0.0000" />
                <FileData Type="MarkedSubImage" Path="Image/IRoom/CommomRoom/game_icon_ting.png" Plist="Texture/IRoom/CommomRoom.plist" />
                <BlendFunc Src="1" Dst="771" />
              </AbstractNodeData>
              <AbstractNodeData Name="Spr_fangzhuSign" ActionTag="-767367339" Tag="1357" IconVisible="False" LeftMargin="345.6697" RightMargin="-389.6697" TopMargin="166.8182" BottomMargin="-210.8182" ctype="SpriteObjectData">
                <Size X="44.0000" Y="44.0000" />
                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                <Position X="367.6697" Y="-188.8182" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition />
                <PreSize X="0.0000" Y="0.0000" />
                <FileData Type="MarkedSubImage" Path="Image/IRoom/CommomRoom/game_icon_fang.png" Plist="Texture/IRoom/CommomRoom.plist" />
                <BlendFunc Src="1" Dst="771" />
              </AbstractNodeData>
              <AbstractNodeData Name="Img_playerChatBg_2" Visible="False" ActionTag="326811653" Tag="828" IconVisible="False" LeftMargin="-192.9172" RightMargin="-275.0828" TopMargin="130.7427" BottomMargin="-188.7427" Scale9Enable="True" LeftEage="40" RightEage="40" Scale9OriginX="40" Scale9Width="20" Scale9Height="58" ctype="ImageViewObjectData">
                <Size X="468.0000" Y="58.0000" />
                <Children>
                  <AbstractNodeData Name="Label_msg" ActionTag="-2094430355" Tag="971" IconVisible="False" LeftMargin="13.0000" RightMargin="71.0000" TopMargin="14.5789" BottomMargin="6.4211" FontSize="32" LabelText="快点啊，我等到花儿也谢了" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                    <Size X="384.0000" Y="37.0000" />
                    <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                    <Position X="205.0000" Y="24.9211" />
                    <Scale ScaleX="1.0000" ScaleY="1.0000" />
                    <CColor A="255" R="107" G="64" B="47" />
                    <PrePosition X="0.4380" Y="0.4297" />
                    <PreSize X="0.8205" Y="0.6379" />
                    <OutlineColor A="255" R="255" G="0" B="0" />
                    <ShadowColor A="255" R="110" G="110" B="110" />
                  </AbstractNodeData>
                </Children>
                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                <Position X="41.0828" Y="-159.7427" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition />
                <PreSize X="0.0000" Y="0.0000" />
                <FileData Type="MarkedSubImage" Path="Image/IRoom/UIChat/chat_bg_up.png" Plist="Texture/IRoom/UIChat.plist" />
              </AbstractNodeData>
              <AbstractNodeData Name="Node_2" ActionTag="-406081866" Tag="714" IconVisible="True" LeftMargin="240.3738" RightMargin="-240.3738" TopMargin="144.6467" BottomMargin="-144.6467" ctype="SingleNodeObjectData">
                <Size X="0.0000" Y="0.0000" />
                <AnchorPoint />
                <Position X="240.3738" Y="-144.6467" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition />
                <PreSize X="0.0000" Y="0.0000" />
              </AbstractNodeData>
              <AbstractNodeData Name="Spr_emoji2" ActionTag="64345083" Tag="1454" IconVisible="True" LeftMargin="326.1920" RightMargin="-326.1920" TopMargin="259.5349" BottomMargin="-259.5349" ctype="SingleNodeObjectData">
                <Size X="0.0000" Y="0.0000" />
                <AnchorPoint />
                <Position X="326.1920" Y="-259.5349" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition />
                <PreSize X="0.0000" Y="0.0000" />
              </AbstractNodeData>
              <AbstractNodeData Name="txtZuoLaPao" ActionTag="1843920880" Tag="4125" IconVisible="False" LeftMargin="385.6387" RightMargin="-477.6387" TopMargin="138.6748" BottomMargin="-167.6748" FontSize="25" LabelText="蹲4炮40" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                <Size X="92.0000" Y="29.0000" />
                <AnchorPoint ScaleY="0.5000" />
                <Position X="385.6387" Y="-153.1748" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="0" />
                <PrePosition />
                <PreSize X="0.0000" Y="0.0000" />
                <OutlineColor A="255" R="255" G="0" B="0" />
                <ShadowColor A="255" R="110" G="110" B="110" />
              </AbstractNodeData>
              <AbstractNodeData Name="iconTuoGuanFlag" ActionTag="1237029506" Tag="11893" IconVisible="False" LeftMargin="282.0078" RightMargin="-374.0078" TopMargin="111.5324" BottomMargin="-203.5324" ctype="SpriteObjectData">
                <Size X="92.0000" Y="92.0000" />
                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                <Position X="328.0078" Y="-157.5324" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition />
                <PreSize X="0.0000" Y="0.0000" />
                <FileData Type="MarkedSubImage" Path="Image/IRoom/CommomRoom/game_icon_tuoguan.png" Plist="Texture/IRoom/CommomRoom.plist" />
                <BlendFunc Src="1" Dst="771" />
              </AbstractNodeData>
            </Children>
            <AnchorPoint />
            <Position X="640.0000" Y="717.1200" />
            <Scale ScaleX="1.0000" ScaleY="1.0000" />
            <CColor A="255" R="255" G="255" B="255" />
            <PrePosition X="0.5000" Y="0.9960" />
            <PreSize X="0.0000" Y="0.0000" />
          </AbstractNodeData>
          <AbstractNodeData Name="Node_playerInfo_3" ActionTag="-1186867949" Tag="347" IconVisible="True" PositionPercentXEnabled="True" PositionPercentYEnabled="True" LeftMargin="80.0000" RightMargin="1200.0000" TopMargin="244.8000" BottomMargin="475.2000" ctype="SingleNodeObjectData">
            <Size X="0.0000" Y="0.0000" />
            <Children>
              <AbstractNodeData Name="headallbk" ActionTag="555051047" Tag="190" IconVisible="False" LeftMargin="-24.7362" RightMargin="-21.2638" TopMargin="-49.6309" BottomMargin="3.6309" ctype="SpriteObjectData">
                <Size X="46.0000" Y="46.0000" />
                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                <Position X="-1.7362" Y="26.6309" />
                <Scale ScaleX="0.8200" ScaleY="0.8200" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition />
                <PreSize X="0.0000" Y="0.0000" />
                <FileData Type="Default" Path="Default/Sprite.png" Plist="" />
                <BlendFunc Src="770" Dst="1" />
              </AbstractNodeData>
              <AbstractNodeData Name="Spr_head" ActionTag="-883161430" Tag="348" IconVisible="False" LeftMargin="-50.0000" RightMargin="-50.0000" TopMargin="-92.0000" BottomMargin="-8.0000" ctype="SpriteObjectData">
                <Size X="100.0000" Y="100.0000" />
                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                <Position Y="42.0000" />
                <Scale ScaleX="0.9000" ScaleY="0.9000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition />
                <PreSize X="0.0000" Y="0.0000" />
                <FileData Type="MarkedSubImage" Path="Image/GComm/comm_head_icon.png" Plist="Texture/GComm.plist" />
                <BlendFunc Src="1" Dst="771" />
              </AbstractNodeData>
              <AbstractNodeData Name="Btn_headFrame" ActionTag="161209540" Tag="41" IconVisible="False" LeftMargin="-53.9606" RightMargin="-55.0394" TopMargin="-92.5391" BottomMargin="-15.4609" TouchEnable="True" FontSize="14" LeftEage="15" RightEage="15" TopEage="11" BottomEage="11" Scale9OriginX="15" Scale9OriginY="11" Scale9Width="59" Scale9Height="67" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="ButtonObjectData">
                <Size X="109.0000" Y="108.0000" />
                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                <Position X="0.5394" Y="38.5391" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition />
                <PreSize X="0.0000" Y="0.0000" />
                <TextColor A="255" R="65" G="65" B="70" />
                <PressedFileData Type="MarkedSubImage" Path="Image/GComm/comm_head_frame.png" Plist="Texture/GComm.plist" />
                <NormalFileData Type="MarkedSubImage" Path="Image/GComm/comm_head_frame.png" Plist="Texture/GComm.plist" />
                <OutlineColor A="255" R="255" G="0" B="0" />
                <ShadowColor A="255" R="110" G="110" B="110" />
              </AbstractNodeData>
              <AbstractNodeData Name="Label_nickname" ActionTag="-1088039670" Tag="350" IconVisible="False" LeftMargin="-34.3155" RightMargin="-37.6845" TopMargin="-120.3918" BottomMargin="92.3918" FontSize="24" LabelText="李晓明" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ShadowEnabled="True" ctype="TextObjectData">
                <Size X="72.0000" Y="28.0000" />
                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                <Position X="1.6845" Y="106.3918" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="250" G="180" B="110" />
                <PrePosition />
                <PreSize X="0.0000" Y="0.0000" />
                <FontResource Type="Default" Path="" Plist="" />
                <OutlineColor A="255" R="255" G="0" B="0" />
                <ShadowColor A="255" R="0" G="0" B="0" />
              </AbstractNodeData>
              <AbstractNodeData Name="Label_score" ActionTag="2112298244" Tag="351" IconVisible="False" LeftMargin="-29.2701" RightMargin="-24.7299" TopMargin="11.7381" BottomMargin="-39.7381" FontSize="24" LabelText="1000" OutlineEnabled="True" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ShadowEnabled="True" ctype="TextObjectData">
                <Size X="54.0000" Y="28.0000" />
                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                <Position X="-2.2701" Y="-25.7381" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition />
                <PreSize X="0.0000" Y="0.0000" />
                <OutlineColor A="255" R="0" G="0" B="0" />
                <ShadowColor A="255" R="26" G="26" B="26" />
              </AbstractNodeData>
              <AbstractNodeData Name="Spr_offLineSign" ActionTag="1053050621" Tag="445" IconVisible="False" LeftMargin="-61.2200" RightMargin="37.2200" TopMargin="-8.4400" BottomMargin="-15.5600" ctype="SpriteObjectData">
                <Size X="24.0000" Y="24.0000" />
                <AnchorPoint />
                <Position X="-61.2200" Y="-15.5600" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition />
                <PreSize X="0.0000" Y="0.0000" />
                <FileData Type="MarkedSubImage" Path="Image/IRoom/CommomRoom/game_icon_offline.png" Plist="Texture/IRoom/CommomRoom.plist" />
                <BlendFunc Src="1" Dst="771" />
              </AbstractNodeData>
              <AbstractNodeData Name="Spr_bankerSign" ActionTag="523750824" Tag="793" IconVisible="False" LeftMargin="5.1931" RightMargin="-76.1931" TopMargin="-124.3271" BottomMargin="37.3271" ctype="SpriteObjectData">
                <Size X="71.0000" Y="87.0000" />
                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                <Position X="40.6931" Y="80.8271" />
                <Scale ScaleX="0.5000" ScaleY="0.5000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition />
                <PreSize X="0.0000" Y="0.0000" />
                <FileData Type="MarkedSubImage" Path="Image/IRoom/CommomRoom/game_icon_zhuang.png" Plist="Texture/IRoom/CommomRoom.plist" />
                <BlendFunc Src="1" Dst="771" />
              </AbstractNodeData>
              <AbstractNodeData Name="Spr_tingSign" ActionTag="-326535802" Tag="3375" IconVisible="False" LeftMargin="-82.6653" RightMargin="11.6653" TopMargin="-133.4004" BottomMargin="46.4004" ctype="SpriteObjectData">
                <Size X="71.0000" Y="87.0000" />
                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                <Position X="-47.1653" Y="89.9004" />
                <Scale ScaleX="0.5000" ScaleY="0.5000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition />
                <PreSize X="0.0000" Y="0.0000" />
                <FileData Type="MarkedSubImage" Path="Image/IRoom/CommomRoom/game_icon_ting.png" Plist="Texture/IRoom/CommomRoom.plist" />
                <BlendFunc Src="1" Dst="771" />
              </AbstractNodeData>
              <AbstractNodeData Name="Spr_fangzhuSign" ActionTag="600605058" Tag="1359" IconVisible="False" LeftMargin="16.4101" RightMargin="-60.4101" TopMargin="-33.3242" BottomMargin="-10.6758" ctype="SpriteObjectData">
                <Size X="44.0000" Y="44.0000" />
                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                <Position X="38.4101" Y="11.3242" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition />
                <PreSize X="0.0000" Y="0.0000" />
                <FileData Type="MarkedSubImage" Path="Image/IRoom/CommomRoom/game_icon_fang.png" Plist="Texture/IRoom/CommomRoom.plist" />
                <BlendFunc Src="1" Dst="771" />
              </AbstractNodeData>
              <AbstractNodeData Name="Img_playerChatBg_3" ActionTag="670700400" VisibleForFrame="False" Tag="826" IconVisible="False" LeftMargin="54.8736" RightMargin="-499.8736" TopMargin="-68.1703" BottomMargin="10.1703" Scale9Enable="True" LeftEage="40" RightEage="40" Scale9OriginX="40" Scale9Width="20" Scale9Height="58" ctype="ImageViewObjectData">
                <Size X="445.0000" Y="58.0000" />
                <Children>
                  <AbstractNodeData Name="Label_msg" ActionTag="-2064739252" Tag="972" IconVisible="False" LeftMargin="27.0002" RightMargin="33.9998" TopMargin="12.4999" BottomMargin="8.5001" FontSize="32" LabelText="快点啊，我等到花儿也谢了" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                    <Size X="384.0000" Y="37.0000" />
                    <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                    <Position X="219.0002" Y="27.0001" />
                    <Scale ScaleX="1.0000" ScaleY="1.0000" />
                    <CColor A="255" R="107" G="64" B="47" />
                    <PrePosition X="0.4921" Y="0.4655" />
                    <PreSize X="0.8629" Y="0.6379" />
                    <OutlineColor A="255" R="255" G="0" B="0" />
                    <ShadowColor A="255" R="110" G="110" B="110" />
                  </AbstractNodeData>
                </Children>
                <AnchorPoint ScaleY="0.5000" />
                <Position X="54.8736" Y="39.1703" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition />
                <PreSize X="0.0000" Y="0.0000" />
                <FileData Type="MarkedSubImage" Path="Image/IRoom/UIChat/chat_bg_left.png" Plist="Texture/IRoom/UIChat.plist" />
              </AbstractNodeData>
              <AbstractNodeData Name="Node_3" ActionTag="-1715010922" Tag="715" IconVisible="True" LeftMargin="88.4507" RightMargin="-88.4507" TopMargin="-58.1960" BottomMargin="58.1960" ctype="SingleNodeObjectData">
                <Size X="0.0000" Y="0.0000" />
                <AnchorPoint />
                <Position X="88.4507" Y="58.1960" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition />
                <PreSize X="0.0000" Y="0.0000" />
              </AbstractNodeData>
              <AbstractNodeData Name="Spr_emoji3" ActionTag="-1264312714" Tag="1457" IconVisible="True" LeftMargin="105.4919" RightMargin="-105.4919" TopMargin="-44.8056" BottomMargin="44.8056" ctype="SingleNodeObjectData">
                <Size X="0.0000" Y="0.0000" />
                <AnchorPoint />
                <Position X="105.4919" Y="44.8056" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition />
                <PreSize X="0.0000" Y="0.0000" />
              </AbstractNodeData>
              <AbstractNodeData Name="txtZuoLaPao" ActionTag="1846959565" Tag="4094" IconVisible="False" LeftMargin="-51.5899" RightMargin="-40.4101" TopMargin="35.4100" BottomMargin="-64.4100" FontSize="25" LabelText="蹲4炮40" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                <Size X="92.0000" Y="29.0000" />
                <AnchorPoint ScaleY="0.5000" />
                <Position X="-51.5899" Y="-49.9100" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="0" />
                <PrePosition />
                <PreSize X="0.0000" Y="0.0000" />
                <OutlineColor A="255" R="255" G="0" B="0" />
                <ShadowColor A="255" R="110" G="110" B="110" />
              </AbstractNodeData>
              <AbstractNodeData Name="iconTuoGuanFlag" ActionTag="239936881" Tag="11892" IconVisible="False" LeftMargin="-46.7477" RightMargin="-45.2523" TopMargin="-87.6812" BottomMargin="-4.3188" ctype="SpriteObjectData">
                <Size X="92.0000" Y="92.0000" />
                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                <Position X="-0.7477" Y="41.6812" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition />
                <PreSize X="0.0000" Y="0.0000" />
                <FileData Type="MarkedSubImage" Path="Image/IRoom/CommomRoom/game_icon_tuoguan.png" Plist="Texture/IRoom/CommomRoom.plist" />
                <BlendFunc Src="1" Dst="771" />
              </AbstractNodeData>
            </Children>
            <AnchorPoint />
            <Position X="80.0000" Y="475.2000" />
            <Scale ScaleX="1.0000" ScaleY="1.0000" />
            <CColor A="255" R="255" G="255" B="255" />
            <PrePosition X="0.0625" Y="0.6600" />
            <PreSize X="0.0000" Y="0.0000" />
          </AbstractNodeData>
          <AbstractNodeData Name="Node_playerInfo_4" ActionTag="1018942479" Tag="209" IconVisible="True" PositionPercentXEnabled="True" PositionPercentYEnabled="True" LeftMargin="80.0000" RightMargin="1200.0000" TopMargin="439.2000" BottomMargin="280.8000" ctype="SingleNodeObjectData">
            <Size X="0.0000" Y="0.0000" />
            <Children>
              <AbstractNodeData Name="headallbk" ActionTag="-1642930031" Tag="210" IconVisible="False" LeftMargin="-24.7362" RightMargin="-21.2638" TopMargin="-49.6309" BottomMargin="3.6309" ctype="SpriteObjectData">
                <Size X="46.0000" Y="46.0000" />
                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                <Position X="-1.7362" Y="26.6309" />
                <Scale ScaleX="0.8200" ScaleY="0.8200" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition />
                <PreSize X="0.0000" Y="0.0000" />
                <FileData Type="Default" Path="Default/Sprite.png" Plist="" />
                <BlendFunc Src="770" Dst="1" />
              </AbstractNodeData>
              <AbstractNodeData Name="Spr_head" ActionTag="-137718517" Tag="211" IconVisible="False" LeftMargin="-50.0000" RightMargin="-50.0000" TopMargin="-92.0000" BottomMargin="-8.0000" ctype="SpriteObjectData">
                <Size X="100.0000" Y="100.0000" />
                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                <Position Y="42.0000" />
                <Scale ScaleX="0.9000" ScaleY="0.9000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition />
                <PreSize X="0.0000" Y="0.0000" />
                <FileData Type="MarkedSubImage" Path="Image/GComm/comm_head_icon.png" Plist="Texture/GComm.plist" />
                <BlendFunc Src="1" Dst="771" />
              </AbstractNodeData>
              <AbstractNodeData Name="Btn_headFrame" ActionTag="283824846" Tag="212" IconVisible="False" LeftMargin="-53.8797" RightMargin="-55.1203" TopMargin="-91.9913" BottomMargin="-16.0087" TouchEnable="True" FontSize="14" LeftEage="15" RightEage="15" TopEage="11" BottomEage="11" Scale9OriginX="15" Scale9OriginY="11" Scale9Width="59" Scale9Height="67" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="ButtonObjectData">
                <Size X="109.0000" Y="108.0000" />
                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                <Position X="0.6203" Y="37.9913" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition />
                <PreSize X="0.0000" Y="0.0000" />
                <TextColor A="255" R="65" G="65" B="70" />
                <PressedFileData Type="MarkedSubImage" Path="Image/GComm/comm_head_frame.png" Plist="Texture/GComm.plist" />
                <NormalFileData Type="MarkedSubImage" Path="Image/GComm/comm_head_frame.png" Plist="Texture/GComm.plist" />
                <OutlineColor A="255" R="255" G="0" B="0" />
                <ShadowColor A="255" R="110" G="110" B="110" />
              </AbstractNodeData>
              <AbstractNodeData Name="Label_nickname" ActionTag="703640783" Tag="213" IconVisible="False" LeftMargin="-34.3155" RightMargin="-37.6845" TopMargin="-120.3918" BottomMargin="92.3918" FontSize="24" LabelText="李晓明" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ShadowEnabled="True" ctype="TextObjectData">
                <Size X="72.0000" Y="28.0000" />
                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                <Position X="1.6845" Y="106.3918" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="250" G="180" B="110" />
                <PrePosition />
                <PreSize X="0.0000" Y="0.0000" />
                <FontResource Type="Default" Path="" Plist="" />
                <OutlineColor A="255" R="255" G="0" B="0" />
                <ShadowColor A="255" R="0" G="0" B="0" />
              </AbstractNodeData>
              <AbstractNodeData Name="Label_score" ActionTag="603720155" Tag="214" IconVisible="False" LeftMargin="-29.2701" RightMargin="-24.7299" TopMargin="11.7381" BottomMargin="-39.7381" FontSize="24" LabelText="1000" OutlineEnabled="True" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ShadowEnabled="True" ctype="TextObjectData">
                <Size X="54.0000" Y="28.0000" />
                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                <Position X="-2.2701" Y="-25.7381" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition />
                <PreSize X="0.0000" Y="0.0000" />
                <OutlineColor A="255" R="0" G="0" B="0" />
                <ShadowColor A="255" R="26" G="26" B="26" />
              </AbstractNodeData>
              <AbstractNodeData Name="Spr_offLineSign" ActionTag="1789016982" Tag="215" IconVisible="False" LeftMargin="-60.2209" RightMargin="36.2209" TopMargin="-11.4362" BottomMargin="-12.5638" ctype="SpriteObjectData">
                <Size X="24.0000" Y="24.0000" />
                <AnchorPoint />
                <Position X="-60.2209" Y="-12.5638" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition />
                <PreSize X="0.0000" Y="0.0000" />
                <FileData Type="MarkedSubImage" Path="Image/IRoom/CommomRoom/game_icon_offline.png" Plist="Texture/IRoom/CommomRoom.plist" />
                <BlendFunc Src="1" Dst="771" />
              </AbstractNodeData>
              <AbstractNodeData Name="Spr_bankerSign" ActionTag="-999407252" Tag="216" IconVisible="False" LeftMargin="7.3438" RightMargin="-78.3438" TopMargin="-124.8574" BottomMargin="37.8574" ctype="SpriteObjectData">
                <Size X="71.0000" Y="87.0000" />
                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                <Position X="42.8438" Y="81.3574" />
                <Scale ScaleX="0.5000" ScaleY="0.5000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition />
                <PreSize X="0.0000" Y="0.0000" />
                <FileData Type="MarkedSubImage" Path="Image/IRoom/CommomRoom/game_icon_zhuang.png" Plist="Texture/IRoom/CommomRoom.plist" />
                <BlendFunc Src="1" Dst="771" />
              </AbstractNodeData>
              <AbstractNodeData Name="Spr_tingSign" ActionTag="1307967580" Tag="3374" IconVisible="False" LeftMargin="-83.2893" RightMargin="12.2893" TopMargin="-132.2624" BottomMargin="45.2624" ctype="SpriteObjectData">
                <Size X="71.0000" Y="87.0000" />
                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                <Position X="-47.7893" Y="88.7624" />
                <Scale ScaleX="0.5000" ScaleY="0.5000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition />
                <PreSize X="0.0000" Y="0.0000" />
                <FileData Type="MarkedSubImage" Path="Image/IRoom/CommomRoom/game_icon_ting.png" Plist="Texture/IRoom/CommomRoom.plist" />
                <BlendFunc Src="1" Dst="771" />
              </AbstractNodeData>
              <AbstractNodeData Name="Spr_fangzhuSign" ActionTag="1760806406" Tag="1356" IconVisible="False" LeftMargin="10.6956" RightMargin="-54.6956" TopMargin="-34.0386" BottomMargin="-9.9614" ctype="SpriteObjectData">
                <Size X="44.0000" Y="44.0000" />
                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                <Position X="32.6956" Y="12.0386" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition />
                <PreSize X="0.0000" Y="0.0000" />
                <FileData Type="MarkedSubImage" Path="Image/IRoom/CommomRoom/game_icon_fang.png" Plist="Texture/IRoom/CommomRoom.plist" />
                <BlendFunc Src="1" Dst="771" />
              </AbstractNodeData>
              <AbstractNodeData Name="txtZuoLaPao" ActionTag="-1378680278" Tag="4063" IconVisible="False" LeftMargin="-51.5899" RightMargin="-40.4101" TopMargin="34.0569" BottomMargin="-63.0569" FontSize="25" LabelText="蹲4炮40" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                <Size X="92.0000" Y="29.0000" />
                <AnchorPoint ScaleY="0.5000" />
                <Position X="-51.5899" Y="-48.5569" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="0" />
                <PrePosition />
                <PreSize X="0.0000" Y="0.0000" />
                <OutlineColor A="255" R="255" G="0" B="0" />
                <ShadowColor A="255" R="110" G="110" B="110" />
              </AbstractNodeData>
              <AbstractNodeData Name="Img_playerChatBg_4" Visible="False" ActionTag="-215488190" Tag="829" IconVisible="False" LeftMargin="61.6949" RightMargin="-529.6949" TopMargin="-98.4209" BottomMargin="40.4209" Scale9Enable="True" LeftEage="42" RightEage="40" TopEage="1" BottomEage="1" Scale9OriginX="42" Scale9OriginY="1" Scale9Width="18" Scale9Height="56" ctype="ImageViewObjectData">
                <Size X="468.0000" Y="58.0000" />
                <Children>
                  <AbstractNodeData Name="Label_msg" ActionTag="1642378692" Tag="973" IconVisible="False" LeftMargin="18.0002" RightMargin="65.9998" TopMargin="6.5000" BottomMargin="14.5000" FontSize="32" LabelText="快点啊，我等到花儿也谢了" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                    <Size X="384.0000" Y="37.0000" />
                    <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                    <Position X="210.0002" Y="33.0000" />
                    <Scale ScaleX="1.0000" ScaleY="1.0000" />
                    <CColor A="255" R="107" G="64" B="47" />
                    <PrePosition X="0.4487" Y="0.5690" />
                    <PreSize X="0.8205" Y="0.6379" />
                    <OutlineColor A="255" R="255" G="0" B="0" />
                    <ShadowColor A="255" R="110" G="110" B="110" />
                  </AbstractNodeData>
                </Children>
                <AnchorPoint />
                <Position X="61.6949" Y="40.4209" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition />
                <PreSize X="0.0000" Y="0.0000" />
                <FileData Type="MarkedSubImage" Path="Image/IRoom/UIChat/chat_bg_down.png" Plist="Texture/IRoom/UIChat.plist" />
              </AbstractNodeData>
              <AbstractNodeData Name="Node_4" ActionTag="-461377420" Tag="716" IconVisible="True" LeftMargin="85.8427" RightMargin="-85.8427" TopMargin="-63.3832" BottomMargin="63.3832" ctype="SingleNodeObjectData">
                <Size X="0.0000" Y="0.0000" />
                <AnchorPoint />
                <Position X="85.8427" Y="63.3832" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition />
                <PreSize X="0.0000" Y="0.0000" />
              </AbstractNodeData>
              <AbstractNodeData Name="iconTuoGuanFlag" ActionTag="-1068713988" Tag="11891" IconVisible="False" LeftMargin="-46.7478" RightMargin="-45.2522" TopMargin="-88.6812" BottomMargin="-3.3188" ctype="SpriteObjectData">
                <Size X="92.0000" Y="92.0000" />
                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                <Position X="-0.7478" Y="42.6812" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition />
                <PreSize X="0.0000" Y="0.0000" />
                <FileData Type="MarkedSubImage" Path="Image/IRoom/CommomRoom/game_icon_tuoguan.png" Plist="Texture/IRoom/CommomRoom.plist" />
                <BlendFunc Src="1" Dst="771" />
              </AbstractNodeData>
              <AbstractNodeData Name="Spr_emoji4" ActionTag="964580528" Tag="1460" IconVisible="True" LeftMargin="105.3360" RightMargin="-105.3360" TopMargin="-42.3906" BottomMargin="42.3906" ctype="SingleNodeObjectData">
                <Size X="0.0000" Y="0.0000" />
                <AnchorPoint />
                <Position X="105.3360" Y="42.3906" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition />
                <PreSize X="0.0000" Y="0.0000" />
              </AbstractNodeData>
            </Children>
            <AnchorPoint />
            <Position X="80.0000" Y="280.8000" />
            <Scale ScaleX="1.0000" ScaleY="1.0000" />
            <CColor A="255" R="255" G="255" B="255" />
            <PrePosition X="0.0625" Y="0.3900" />
            <PreSize X="0.0000" Y="0.0000" />
          </AbstractNodeData>
          <AbstractNodeData Name="Btn_showHuCards" ActionTag="-1661992688" Tag="755" IconVisible="False" LeftMargin="201.1001" RightMargin="998.8999" TopMargin="444.6900" BottomMargin="187.3100" TouchEnable="True" FontSize="36" LeftEage="15" RightEage="15" TopEage="11" BottomEage="11" Scale9OriginX="15" Scale9OriginY="11" Scale9Width="50" Scale9Height="66" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="ButtonObjectData">
            <Size X="80.0000" Y="88.0000" />
            <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
            <Position X="241.1001" Y="231.3100" />
            <Scale ScaleX="1.0000" ScaleY="1.0000" />
            <CColor A="255" R="255" G="255" B="255" />
            <PrePosition X="0.1884" Y="0.3213" />
            <PreSize X="0.0625" Y="0.1222" />
            <TextColor A="255" R="255" G="255" B="255" />
            <NormalFileData Type="MarkedSubImage" Path="Image/IRoom/CommomRoom/game_btn_showHucards.png" Plist="Texture/IRoom/CommomRoom.plist" />
            <OutlineColor A="255" R="255" G="0" B="0" />
            <ShadowColor A="255" R="110" G="110" B="110" />
          </AbstractNodeData>
          <AbstractNodeData Name="imgBGTingTip" ActionTag="357265490" Tag="3766" IconVisible="False" PositionPercentXEnabled="True" PositionPercentYEnabled="True" LeftMargin="19.2000" RightMargin="1020.8000" TopMargin="509.8240" BottomMargin="140.1760" TouchEnable="True" Scale9Enable="True" LeftEage="19" RightEage="19" TopEage="19" BottomEage="19" Scale9OriginX="19" Scale9OriginY="19" Scale9Width="22" Scale9Height="22" ctype="ImageViewObjectData">
            <Size X="240.0000" Y="70.0000" />
            <Children>
              <AbstractNodeData Name="spriteTxtTing" ActionTag="-1891249966" Tag="3767" IconVisible="False" PositionPercentYEnabled="True" LeftMargin="10.1901" RightMargin="180.8099" TopMargin="16.1820" BottomMargin="8.8180" ctype="SpriteObjectData">
                <Size X="49.0000" Y="45.0000" />
                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                <Position X="34.6901" Y="31.3180" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition X="0.1445" Y="0.4474" />
                <PreSize X="0.2042" Y="0.6429" />
                <FileData Type="MarkedSubImage" Path="Image/IRoom/CommomRoom/game_txt_ting.png" Plist="Texture/IRoom/CommomRoom.plist" />
                <BlendFunc Src="1" Dst="771" />
              </AbstractNodeData>
              <AbstractNodeData Name="lvTingMJ" ActionTag="393103829" Tag="3768" IconVisible="False" PositionPercentYEnabled="True" LeftMargin="65.2106" RightMargin="34.7894" TopMargin="7.8750" BottomMargin="6.1250" TouchEnable="True" ClipAble="True" BackColorAlpha="0" ComboBoxIndex="1" ColorAngle="90.0000" Scale9Width="1" Scale9Height="1" ScrollDirectionType="0" ItemMargin="2" VerticalType="Align_VerticalCenter" ctype="ListViewObjectData">
                <Size X="140.0000" Y="56.0000" />
                <AnchorPoint ScaleY="0.5000" />
                <Position X="65.2106" Y="34.1250" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition X="0.2717" Y="0.4875" />
                <PreSize X="0.5833" Y="0.8000" />
                <SingleColor A="255" R="150" G="150" B="255" />
                <FirstColor A="255" R="150" G="150" B="255" />
                <EndColor A="255" R="255" G="255" B="255" />
                <ColorVector ScaleY="1.0000" />
              </AbstractNodeData>
            </Children>
            <AnchorPoint ScaleY="0.5000" />
            <Position X="19.2000" Y="175.1760" />
            <Scale ScaleX="1.0000" ScaleY="1.0000" />
            <CColor A="255" R="255" G="255" B="255" />
            <PrePosition X="0.0150" Y="0.2433" />
            <PreSize X="0.1875" Y="0.0972" />
            <FileData Type="MarkedSubImage" Path="Image/IRoom/CommomRoom/game_bg_ting_tip.png" Plist="Texture/IRoom/CommomRoom.plist" />
          </AbstractNodeData>
        </Children>
      </ObjectData>
    </Content>
  </Content>
</GameFile>