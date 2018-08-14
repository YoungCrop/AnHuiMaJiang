<GameFile>
  <PropertyGroup Name="UISettlementOneRound" Type="Layer" ID="317c8eab-bbb8-4510-8ec9-cd98d2891e84" Version="3.10.0.0" />
  <Content ctype="GameProjectContent">
    <Content>
      <Animation Duration="0" Speed="1.0000" />
      <ObjectData Name="Layer" Tag="701" ctype="GameLayerObjectData">
        <Size X="1280.0000" Y="720.0000" />
        <Children>
          <AbstractNodeData Name="Node_reportTitle" ActionTag="-1312591850" Tag="166" IconVisible="True" PositionPercentXEnabled="True" PositionPercentYEnabled="True" LeftMargin="629.7600" RightMargin="650.2400" TopMargin="337.2480" BottomMargin="382.7520" ctype="SingleNodeObjectData">
            <Size X="0.0000" Y="0.0000" />
            <Children>
              <AbstractNodeData Name="sprRoundBg" ActionTag="691335994" Tag="2070" IconVisible="False" LeftMargin="-274.3098" RightMargin="-277.6902" TopMargin="-198.6410" BottomMargin="-238.3590" ctype="SpriteObjectData">
                <Size X="552.0000" Y="437.0000" />
                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                <Position X="1.6902" Y="-19.8590" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition />
                <PreSize X="0.0000" Y="0.0000" />
                <FileData Type="MarkedSubImage" Path="Image/GameSub/GameDDZ/play_round_bg.png" Plist="Texture/GameSub/GameDDZ.plist" />
                <BlendFunc Src="1" Dst="771" />
              </AbstractNodeData>
              <AbstractNodeData Name="spriteTitleLose" ActionTag="-1333628017" Tag="162" IconVisible="False" LeftMargin="-331.6275" RightMargin="-334.3725" TopMargin="-238.9423" BottomMargin="121.9423" ctype="SpriteObjectData">
                <Size X="666.0000" Y="117.0000" />
                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                <Position X="1.3725" Y="180.4423" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition />
                <PreSize X="0.0000" Y="0.0000" />
                <FileData Type="MarkedSubImage" Path="Image/GameSub/GameDDZ/play_flag_lose.png" Plist="Texture/GameSub/GameDDZ.plist" />
                <BlendFunc Src="1" Dst="771" />
              </AbstractNodeData>
              <AbstractNodeData Name="spriteTitleWin" ActionTag="378634578" Tag="163" IconVisible="False" LeftMargin="-331.6275" RightMargin="-334.3725" TopMargin="-336.9338" BottomMargin="95.9338" ctype="SpriteObjectData">
                <Size X="666.0000" Y="241.0000" />
                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                <Position X="1.3725" Y="216.4338" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition />
                <PreSize X="0.0000" Y="0.0000" />
                <FileData Type="MarkedSubImage" Path="Image/GameSub/GameDDZ/play_flag_win.png" Plist="Texture/GameSub/GameDDZ.plist" />
                <BlendFunc Src="1" Dst="771" />
              </AbstractNodeData>
            </Children>
            <AnchorPoint />
            <Position X="629.7600" Y="382.7520" />
            <Scale ScaleX="1.0000" ScaleY="1.0000" />
            <CColor A="255" R="255" G="255" B="255" />
            <PrePosition X="0.4920" Y="0.5316" />
            <PreSize X="0.0000" Y="0.0000" />
          </AbstractNodeData>
          <AbstractNodeData Name="Node_playerTile" ActionTag="-799830646" Tag="167" IconVisible="True" PositionPercentYEnabled="True" LeftMargin="627.2347" RightMargin="652.7653" TopMargin="335.4480" BottomMargin="384.5520" ctype="SingleNodeObjectData">
            <Size X="0.0000" Y="0.0000" />
            <Children>
              <AbstractNodeData Name="Text_nickname" ActionTag="752162852" Tag="417" IconVisible="False" LeftMargin="-177.1340" RightMargin="121.1340" TopMargin="-112.9583" BottomMargin="80.9583" FontSize="28" LabelText="昵称" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                <Size X="56.0000" Y="32.0000" />
                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                <Position X="-149.1340" Y="96.9583" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="210" B="55" />
                <PrePosition />
                <PreSize X="0.0000" Y="0.0000" />
                <OutlineColor A="255" R="255" G="255" B="255" />
                <ShadowColor A="255" R="110" G="110" B="110" />
              </AbstractNodeData>
              <AbstractNodeData Name="Text_bombbe" ActionTag="835455665" Tag="419" IconVisible="False" LeftMargin="15.8646" RightMargin="-73.8646" TopMargin="-116.6294" BottomMargin="79.6294" FontSize="28" LabelText="炸弹" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                <Size X="58.0000" Y="37.0000" />
                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                <Position X="44.8646" Y="98.1294" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="210" B="55" />
                <PrePosition />
                <PreSize X="0.0000" Y="0.0000" />
                <FontResource Type="Normal" Path="fonts/DroidDefault.ttf" Plist="" />
                <OutlineColor A="255" R="255" G="0" B="0" />
                <ShadowColor A="255" R="110" G="110" B="110" />
              </AbstractNodeData>
              <AbstractNodeData Name="Text_score" ActionTag="-1322565125" Tag="420" IconVisible="False" LeftMargin="172.8628" RightMargin="-230.8628" TopMargin="-116.6294" BottomMargin="79.6294" FontSize="28" LabelText="积分" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                <Size X="58.0000" Y="37.0000" />
                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                <Position X="201.8628" Y="98.1294" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="210" B="55" />
                <PrePosition />
                <PreSize X="0.0000" Y="0.0000" />
                <FontResource Type="Normal" Path="fonts/DroidDefault.ttf" Plist="" />
                <OutlineColor A="255" R="255" G="0" B="0" />
                <ShadowColor A="255" R="110" G="110" B="110" />
              </AbstractNodeData>
            </Children>
            <AnchorPoint />
            <Position X="627.2347" Y="384.5520" />
            <Scale ScaleX="1.0000" ScaleY="1.0000" />
            <CColor A="255" R="255" G="255" B="255" />
            <PrePosition X="0.4900" Y="0.5341" />
            <PreSize X="0.0000" Y="0.0000" />
          </AbstractNodeData>
          <AbstractNodeData Name="Node_playerReport_1" ActionTag="-580710440" Tag="288" IconVisible="True" PositionPercentYEnabled="True" LeftMargin="628.9153" RightMargin="651.0847" TopMargin="335.5920" BottomMargin="384.4080" ctype="SingleNodeObjectData">
            <Size X="0.0000" Y="0.0000" />
            <Children>
              <AbstractNodeData Name="Label_nickname" ActionTag="907631132" Tag="289" IconVisible="False" HorizontalEdge="LeftEdge" LeftMargin="-193.1995" RightMargin="80.1995" TopMargin="-73.5911" BottomMargin="36.5911" FontSize="28" LabelText="王小明明" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                <Size X="113.0000" Y="37.0000" />
                <AnchorPoint ScaleY="0.5000" />
                <Position X="-193.1995" Y="55.0911" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition />
                <PreSize X="0.0000" Y="0.0000" />
                <FontResource Type="Normal" Path="fonts/DroidDefault.ttf" Plist="" />
                <OutlineColor A="255" R="255" G="0" B="0" />
                <ShadowColor A="255" R="110" G="110" B="110" />
              </AbstractNodeData>
              <AbstractNodeData Name="Label_bombenum" ActionTag="-1006523367" Tag="291" IconVisible="False" HorizontalEdge="LeftEdge" LeftMargin="22.3029" RightMargin="-61.3029" TopMargin="-75.3231" BottomMargin="30.3231" FontSize="34" LabelText="15" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                <Size X="39.0000" Y="45.0000" />
                <AnchorPoint ScaleX="0.5000" ScaleY="0.5504" />
                <Position X="41.8029" Y="55.0911" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition />
                <PreSize X="0.0000" Y="0.0000" />
                <FontResource Type="Normal" Path="fonts/DroidDefault.ttf" Plist="" />
                <OutlineColor A="255" R="255" G="0" B="0" />
                <ShadowColor A="255" R="110" G="110" B="110" />
              </AbstractNodeData>
              <AbstractNodeData Name="Label_score" ActionTag="-396449906" Tag="292" IconVisible="False" HorizontalEdge="LeftEdge" LeftMargin="170.8070" RightMargin="-221.8070" TopMargin="-77.5889" BottomMargin="32.5889" FontSize="34" LabelText="-16" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                <Size X="51.0000" Y="45.0000" />
                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                <Position X="196.3070" Y="55.0889" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition />
                <PreSize X="0.0000" Y="0.0000" />
                <FontResource Type="Normal" Path="fonts/DroidDefault.ttf" Plist="" />
                <OutlineColor A="255" R="255" G="0" B="0" />
                <ShadowColor A="255" R="110" G="110" B="110" />
              </AbstractNodeData>
              <AbstractNodeData Name="sprFlagDiZhu" ActionTag="-1127645779" Tag="338" IconVisible="False" LeftMargin="-227.2005" RightMargin="192.2005" TopMargin="-77.2367" BottomMargin="36.2367" ctype="SpriteObjectData">
                <Size X="35.0000" Y="41.0000" />
                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                <Position X="-209.7005" Y="56.7367" />
                <Scale ScaleX="0.8000" ScaleY="0.8000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition />
                <PreSize X="0.0000" Y="0.0000" />
                <FileData Type="MarkedSubImage" Path="Image/GameSub/GameDDZ/play_flag_doudizhu.png" Plist="Texture/GameSub/GameDDZ.plist" />
                <BlendFunc Src="1" Dst="771" />
              </AbstractNodeData>
            </Children>
            <AnchorPoint />
            <Position X="628.9153" Y="384.4080" />
            <Scale ScaleX="1.0000" ScaleY="1.0000" />
            <CColor A="255" R="255" G="255" B="255" />
            <PrePosition X="0.4913" Y="0.5339" />
            <PreSize X="0.0000" Y="0.0000" />
          </AbstractNodeData>
          <AbstractNodeData Name="Node_playerReport_2" ActionTag="-1614391394" Tag="296" IconVisible="True" PositionPercentYEnabled="True" LeftMargin="628.9153" RightMargin="651.0847" TopMargin="335.5920" BottomMargin="384.4080" ctype="SingleNodeObjectData">
            <Size X="0.0000" Y="0.0000" />
            <Children>
              <AbstractNodeData Name="Label_nickname" ActionTag="-627009045" Tag="297" IconVisible="False" LeftMargin="-193.1995" RightMargin="80.1995" TopMargin="-13.5902" BottomMargin="-23.4098" FontSize="28" LabelText="王小明明" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                <Size X="113.0000" Y="37.0000" />
                <AnchorPoint ScaleY="0.5000" />
                <Position X="-193.1995" Y="-4.9098" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition />
                <PreSize X="0.0000" Y="0.0000" />
                <FontResource Type="Normal" Path="fonts/DroidDefault.ttf" Plist="" />
                <OutlineColor A="255" R="255" G="0" B="0" />
                <ShadowColor A="255" R="110" G="110" B="110" />
              </AbstractNodeData>
              <AbstractNodeData Name="Label_bombenum" ActionTag="-1680010236" Tag="299" IconVisible="False" LeftMargin="20.3029" RightMargin="-60.3029" TopMargin="-17.5894" BottomMargin="-27.4106" FontSize="34" LabelText="16" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                <Size X="40.0000" Y="45.0000" />
                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                <Position X="40.3029" Y="-4.9106" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition />
                <PreSize X="0.0000" Y="0.0000" />
                <FontResource Type="Normal" Path="fonts/DroidDefault.ttf" Plist="" />
                <OutlineColor A="255" R="255" G="0" B="0" />
                <ShadowColor A="255" R="110" G="110" B="110" />
              </AbstractNodeData>
              <AbstractNodeData Name="Label_score" ActionTag="-993556529" Tag="300" RotationSkewX="-360.0000" RotationSkewY="-360.0000" IconVisible="False" LeftMargin="167.8031" RightMargin="-226.8031" TopMargin="-17.5895" BottomMargin="-27.4105" FontSize="34" LabelText="X16" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                <Size X="59.0000" Y="45.0000" />
                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                <Position X="197.3031" Y="-4.9105" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition />
                <PreSize X="0.0000" Y="0.0000" />
                <FontResource Type="Normal" Path="fonts/DroidDefault.ttf" Plist="" />
                <OutlineColor A="255" R="255" G="0" B="0" />
                <ShadowColor A="255" R="110" G="110" B="110" />
              </AbstractNodeData>
              <AbstractNodeData Name="sprFlagDiZhu" ActionTag="1499842571" Tag="337" IconVisible="False" LeftMargin="-227.2005" RightMargin="192.2005" TopMargin="-17.2368" BottomMargin="-23.7632" ctype="SpriteObjectData">
                <Size X="35.0000" Y="41.0000" />
                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                <Position X="-209.7005" Y="-3.2632" />
                <Scale ScaleX="0.8000" ScaleY="0.8000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition />
                <PreSize X="0.0000" Y="0.0000" />
                <FileData Type="MarkedSubImage" Path="Image/GameSub/GameDDZ/play_flag_doudizhu.png" Plist="Texture/GameSub/GameDDZ.plist" />
                <BlendFunc Src="1" Dst="771" />
              </AbstractNodeData>
            </Children>
            <AnchorPoint />
            <Position X="628.9153" Y="384.4080" />
            <Scale ScaleX="1.0000" ScaleY="1.0000" />
            <CColor A="255" R="255" G="255" B="255" />
            <PrePosition X="0.4913" Y="0.5339" />
            <PreSize X="0.0000" Y="0.0000" />
          </AbstractNodeData>
          <AbstractNodeData Name="Node_playerReport_3" ActionTag="1905644377" Tag="304" IconVisible="True" PositionPercentYEnabled="True" LeftMargin="628.9153" RightMargin="651.0847" TopMargin="335.5920" BottomMargin="384.4080" ctype="SingleNodeObjectData">
            <Size X="0.0000" Y="0.0000" />
            <Children>
              <AbstractNodeData Name="Label_nickname" ActionTag="-828352838" Tag="305" IconVisible="False" LeftMargin="-193.1995" RightMargin="80.1995" TopMargin="46.4100" BottomMargin="-83.4100" FontSize="28" LabelText="王小明明" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                <Size X="113.0000" Y="37.0000" />
                <AnchorPoint ScaleY="0.5000" />
                <Position X="-193.1995" Y="-64.9100" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition />
                <PreSize X="0.0000" Y="0.0000" />
                <FontResource Type="Normal" Path="fonts/DroidDefault.ttf" Plist="" />
                <OutlineColor A="255" R="255" G="0" B="0" />
                <ShadowColor A="255" R="110" G="110" B="110" />
              </AbstractNodeData>
              <AbstractNodeData Name="Label_bombenum" ActionTag="-1715484258" Tag="307" IconVisible="False" LeftMargin="20.3029" RightMargin="-60.3029" TopMargin="42.4098" BottomMargin="-87.4098" FontSize="34" LabelText="16" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                <Size X="40.0000" Y="45.0000" />
                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                <Position X="40.3029" Y="-64.9098" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition />
                <PreSize X="0.0000" Y="0.0000" />
                <FontResource Type="Normal" Path="fonts/DroidDefault.ttf" Plist="" />
                <OutlineColor A="255" R="255" G="0" B="0" />
                <ShadowColor A="255" R="110" G="110" B="110" />
              </AbstractNodeData>
              <AbstractNodeData Name="sprFlagDiZhu" ActionTag="-956945095" Tag="335" IconVisible="False" LeftMargin="-227.2005" RightMargin="192.2005" TopMargin="42.7639" BottomMargin="-83.7639" ctype="SpriteObjectData">
                <Size X="35.0000" Y="41.0000" />
                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                <Position X="-209.7005" Y="-63.2639" />
                <Scale ScaleX="0.8000" ScaleY="0.8000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition />
                <PreSize X="0.0000" Y="0.0000" />
                <FileData Type="MarkedSubImage" Path="Image/GameSub/GameDDZ/play_flag_doudizhu.png" Plist="Texture/GameSub/GameDDZ.plist" />
                <BlendFunc Src="1" Dst="771" />
              </AbstractNodeData>
              <AbstractNodeData Name="Label_score" ActionTag="-1385719780" Tag="308" IconVisible="False" LeftMargin="171.8031" RightMargin="-222.8031" TopMargin="42.4098" BottomMargin="-87.4098" FontSize="34" LabelText="-16" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                <Size X="51.0000" Y="45.0000" />
                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                <Position X="197.3031" Y="-64.9098" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition />
                <PreSize X="0.0000" Y="0.0000" />
                <FontResource Type="Normal" Path="fonts/DroidDefault.ttf" Plist="" />
                <OutlineColor A="255" R="255" G="0" B="0" />
                <ShadowColor A="255" R="110" G="110" B="110" />
              </AbstractNodeData>
            </Children>
            <AnchorPoint />
            <Position X="628.9153" Y="384.4080" />
            <Scale ScaleX="1.0000" ScaleY="1.0000" />
            <CColor A="255" R="255" G="255" B="255" />
            <PrePosition X="0.4913" Y="0.5339" />
            <PreSize X="0.0000" Y="0.0000" />
          </AbstractNodeData>
          <AbstractNodeData Name="btnNext" ActionTag="491366824" Tag="619" IconVisible="False" PositionPercentXEnabled="True" PositionPercentYEnabled="True" LeftMargin="525.0000" RightMargin="525.0000" TopMargin="497.0400" BottomMargin="144.9600" TouchEnable="True" FontSize="34" LeftEage="15" RightEage="15" TopEage="11" BottomEage="11" Scale9OriginX="15" Scale9OriginY="11" Scale9Width="200" Scale9Height="56" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="ButtonObjectData">
            <Size X="230.0000" Y="78.0000" />
            <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
            <Position X="640.0000" Y="183.9600" />
            <Scale ScaleX="1.0000" ScaleY="1.0000" />
            <CColor A="255" R="255" G="255" B="255" />
            <PrePosition X="0.5000" Y="0.2555" />
            <PreSize X="0.1797" Y="0.1083" />
            <TextColor A="255" R="165" G="42" B="42" />
            <NormalFileData Type="MarkedSubImage" Path="Image/GameSub/GameDDZ/play_btn_next.png" Plist="Texture/GameSub/GameDDZ.plist" />
            <OutlineColor A="255" R="255" G="0" B="0" />
            <ShadowColor A="255" R="110" G="110" B="110" />
          </AbstractNodeData>
          <AbstractNodeData Name="btnExitRoom" ActionTag="-36100193" Tag="1324" IconVisible="False" PositionPercentXEnabled="True" LeftMargin="446.5970" RightMargin="668.4030" TopMargin="494.0985" BottomMargin="166.9015" TouchEnable="True" FontSize="30" ButtonText="退出房间" Scale9Enable="True" LeftEage="15" RightEage="15" TopEage="11" BottomEage="11" Scale9OriginX="15" Scale9OriginY="11" Scale9Width="135" Scale9Height="37" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="ButtonObjectData">
            <Size X="165.0000" Y="59.0000" />
            <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
            <Position X="529.0970" Y="196.4015" />
            <Scale ScaleX="1.0000" ScaleY="1.0000" />
            <CColor A="255" R="255" G="255" B="255" />
            <PrePosition X="0.4134" Y="0.2728" />
            <PreSize X="0.1289" Y="0.0819" />
            <TextColor A="255" R="255" G="255" B="255" />
            <NormalFileData Type="MarkedSubImage" Path="Image/ILobby/UICoin/comm_btn_red.png" Plist="Texture/ILobby/UICoin.plist" />
            <OutlineColor A="255" R="255" G="0" B="0" />
            <ShadowColor A="255" R="110" G="110" B="110" />
          </AbstractNodeData>
          <AbstractNodeData Name="btnAgain" ActionTag="1849203134" Tag="1325" IconVisible="False" PositionPercentXEnabled="True" LeftMargin="648.7681" RightMargin="466.2319" TopMargin="494.0985" BottomMargin="166.9015" TouchEnable="True" FontSize="30" ButtonText="再来一局" Scale9Enable="True" LeftEage="15" RightEage="15" TopEage="11" BottomEage="11" Scale9OriginX="15" Scale9OriginY="11" Scale9Width="135" Scale9Height="37" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="ButtonObjectData">
            <Size X="165.0000" Y="59.0000" />
            <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
            <Position X="731.2681" Y="196.4015" />
            <Scale ScaleX="1.0000" ScaleY="1.0000" />
            <CColor A="255" R="255" G="255" B="255" />
            <PrePosition X="0.5713" Y="0.2728" />
            <PreSize X="0.1289" Y="0.0819" />
            <TextColor A="255" R="255" G="255" B="255" />
            <NormalFileData Type="MarkedSubImage" Path="Image/ILobby/UICoin/comm_btn_red.png" Plist="Texture/ILobby/UICoin.plist" />
            <OutlineColor A="255" R="255" G="0" B="0" />
            <ShadowColor A="255" R="110" G="110" B="110" />
          </AbstractNodeData>
        </Children>
      </ObjectData>
    </Content>
  </Content>
</GameFile>