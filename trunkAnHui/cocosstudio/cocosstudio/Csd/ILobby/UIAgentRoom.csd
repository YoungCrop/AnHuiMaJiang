<GameFile>
  <PropertyGroup Name="UIAgentRoom" Type="Layer" ID="e77c5705-8e25-43b1-84e8-1dcc37dd1f86" Version="3.10.0.0" />
  <Content ctype="GameProjectContent">
    <Content>
      <Animation Duration="0" Speed="1.0000" />
      <ObjectData Name="Layer" Tag="21" ctype="GameLayerObjectData">
        <Size X="1280.0000" Y="720.0000" />
        <Children>
          <AbstractNodeData Name="imgBG" ActionTag="-1195545191" Tag="1588" IconVisible="False" PositionPercentXEnabled="True" PositionPercentYEnabled="True" LeftMargin="20.5000" RightMargin="20.5000" TopMargin="36.5240" BottomMargin="30.4760" Scale9Enable="True" LeftEage="50" RightEage="50" TopEage="40" BottomEage="40" Scale9OriginX="50" Scale9OriginY="40" Scale9Width="1139" Scale9Height="573" ctype="ImageViewObjectData">
            <Size X="1239.0000" Y="653.0000" />
            <Children>
              <AbstractNodeData Name="imgBGUp" ActionTag="-1582455216" Tag="1585" IconVisible="False" PositionPercentXEnabled="True" PositionPercentYEnabled="True" LeftMargin="17.0000" RightMargin="17.0000" TopMargin="64.9691" BottomMargin="33.0309" Scale9Enable="True" LeftEage="30" RightEage="30" TopEage="40" BottomEage="40" Scale9OriginX="30" Scale9OriginY="40" Scale9Width="889" Scale9Height="440" ctype="ImageViewObjectData">
                <Size X="1205.0000" Y="555.0000" />
                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                <Position X="619.5000" Y="310.5309" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition X="0.5000" Y="0.4755" />
                <PreSize X="0.9726" Y="0.8499" />
                <FileData Type="Normal" Path="Image/BigImg/kuang_bg2_cloth.png" Plist="" />
              </AbstractNodeData>
            </Children>
            <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
            <Position X="640.0000" Y="356.9760" />
            <Scale ScaleX="1.0000" ScaleY="1.0000" />
            <CColor A="255" R="255" G="255" B="255" />
            <PrePosition X="0.5000" Y="0.4958" />
            <PreSize X="0.9680" Y="0.9069" />
            <FileData Type="Normal" Path="Image/BigImg/kuang_bg3.png" Plist="" />
          </AbstractNodeData>
          <AbstractNodeData Name="bgBtn" ActionTag="-1028673205" Tag="87" IconVisible="False" PositionPercentXEnabled="True" LeftMargin="467.0000" RightMargin="467.0000" TopMargin="12.3209" BottomMargin="630.6791" ctype="SpriteObjectData">
            <Size X="346.0000" Y="77.0000" />
            <Children>
              <AbstractNodeData Name="spriteComplete" ActionTag="-1670183536" Tag="111" IconVisible="False" LeftMargin="164.6249" RightMargin="10.3751" TopMargin="6.3554" BottomMargin="10.6446" ctype="SpriteObjectData">
                <Size X="171.0000" Y="60.0000" />
                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                <Position X="250.1249" Y="40.6446" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition X="0.7229" Y="0.5279" />
                <PreSize X="0.4942" Y="0.7792" />
                <FileData Type="MarkedSubImage" Path="Image/ILobby/UIAgentRoom/agent_btn_completed.png" Plist="Texture/ILobby/UIAgentRoom.plist" />
                <BlendFunc Src="1" Dst="771" />
              </AbstractNodeData>
              <AbstractNodeData Name="spriteAgent" ActionTag="609849551" Tag="112" IconVisible="False" LeftMargin="8.0774" RightMargin="166.9226" TopMargin="5.9265" BottomMargin="11.0735" ctype="SpriteObjectData">
                <Size X="171.0000" Y="60.0000" />
                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                <Position X="93.5774" Y="41.0735" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition X="0.2705" Y="0.5334" />
                <PreSize X="0.4942" Y="0.7792" />
                <FileData Type="MarkedSubImage" Path="Image/ILobby/UIAgentRoom/agent_btn_record.png" Plist="Texture/ILobby/UIAgentRoom.plist" />
                <BlendFunc Src="1" Dst="771" />
              </AbstractNodeData>
              <AbstractNodeData Name="btnAgentCreate" ActionTag="90604103" Alpha="0" Tag="89" IconVisible="False" LeftMargin="8.0776" RightMargin="166.9224" TopMargin="6.9265" BottomMargin="10.0735" TouchEnable="True" FontSize="14" Scale9Enable="True" LeftEage="15" RightEage="15" TopEage="11" BottomEage="11" Scale9OriginX="15" Scale9OriginY="11" Scale9Width="141" Scale9Height="38" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="ButtonObjectData">
                <Size X="171.0000" Y="60.0000" />
                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                <Position X="93.5776" Y="40.0735" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition X="0.2705" Y="0.5204" />
                <PreSize X="0.4942" Y="0.7792" />
                <TextColor A="255" R="65" G="65" B="70" />
                <DisabledFileData Type="Default" Path="Default/Button_Disable.png" Plist="" />
                <PressedFileData Type="MarkedSubImage" Path="Image/ILobby/UIAgentRoom/agent_btn_record.png" Plist="Texture/ILobby/UIAgentRoom.plist" />
                <NormalFileData Type="MarkedSubImage" Path="Image/ILobby/UIAgentRoom/agent_btn_record.png" Plist="Texture/ILobby/UIAgentRoom.plist" />
                <OutlineColor A="255" R="255" G="0" B="0" />
                <ShadowColor A="255" R="110" G="110" B="110" />
              </AbstractNodeData>
              <AbstractNodeData Name="btnComplete" ActionTag="-1913310457" Alpha="0" Tag="90" IconVisible="False" LeftMargin="164.6248" RightMargin="10.3752" TopMargin="7.3554" BottomMargin="9.6446" TouchEnable="True" FontSize="14" Scale9Enable="True" LeftEage="15" RightEage="15" TopEage="11" BottomEage="11" Scale9OriginX="15" Scale9OriginY="11" Scale9Width="141" Scale9Height="38" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="ButtonObjectData">
                <Size X="171.0000" Y="60.0000" />
                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                <Position X="250.1248" Y="39.6446" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition X="0.7229" Y="0.5149" />
                <PreSize X="0.4942" Y="0.7792" />
                <TextColor A="255" R="65" G="65" B="70" />
                <DisabledFileData Type="Default" Path="Default/Button_Disable.png" Plist="" />
                <PressedFileData Type="MarkedSubImage" Path="Image/ILobby/UIAgentRoom/agent_btn_completed.png" Plist="Texture/ILobby/UIAgentRoom.plist" />
                <NormalFileData Type="MarkedSubImage" Path="Image/ILobby/UIAgentRoom/agent_btn_completed.png" Plist="Texture/ILobby/UIAgentRoom.plist" />
                <OutlineColor A="255" R="255" G="0" B="0" />
                <ShadowColor A="255" R="110" G="110" B="110" />
              </AbstractNodeData>
            </Children>
            <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
            <Position X="640.0000" Y="669.1791" />
            <Scale ScaleX="1.0000" ScaleY="1.0000" />
            <CColor A="255" R="255" G="255" B="255" />
            <PrePosition X="0.5000" Y="0.9294" />
            <PreSize X="0.2703" Y="0.1069" />
            <FileData Type="MarkedSubImage" Path="Image/ILobby/UIAgentRoom/agent_bg_btn.png" Plist="Texture/ILobby/UIAgentRoom.plist" />
            <BlendFunc Src="1" Dst="771" />
          </AbstractNodeData>
          <AbstractNodeData Name="btnRefersh" ActionTag="2041356631" Tag="96" IconVisible="False" LeftMargin="1015.9834" RightMargin="211.0166" TopMargin="41.0618" BottomMargin="629.9382" TouchEnable="True" FontSize="14" Scale9Enable="True" LeftEage="15" RightEage="15" TopEage="11" BottomEage="11" Scale9OriginX="15" Scale9OriginY="11" Scale9Width="23" Scale9Height="27" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="ButtonObjectData">
            <Size X="53.0000" Y="49.0000" />
            <AnchorPoint ScaleX="0.5661" ScaleY="0.3353" />
            <Position X="1045.9867" Y="646.3679" />
            <Scale ScaleX="1.0000" ScaleY="1.0000" />
            <CColor A="255" R="255" G="255" B="255" />
            <PrePosition X="0.8172" Y="0.8977" />
            <PreSize X="0.0414" Y="0.0681" />
            <TextColor A="255" R="65" G="65" B="70" />
            <NormalFileData Type="MarkedSubImage" Path="Image/ILobby/UIAgentRoom/agent_btn_refersh.png" Plist="Texture/ILobby/UIAgentRoom.plist" />
            <OutlineColor A="255" R="255" G="0" B="0" />
            <ShadowColor A="255" R="110" G="110" B="110" />
          </AbstractNodeData>
          <AbstractNodeData Name="nodeTitle" ActionTag="-847479024" Tag="91" IconVisible="True" LeftMargin="641.0132" RightMargin="638.9868" TopMargin="128.8567" BottomMargin="591.1433" ctype="SingleNodeObjectData">
            <Size X="0.0000" Y="0.0000" />
            <Children>
              <AbstractNodeData Name="Text_roomId" ActionTag="431730986" Tag="92" IconVisible="False" LeftMargin="-499.0000" RightMargin="401.0000" TopMargin="-21.0000" BottomMargin="-21.0000" FontSize="32" LabelText="房间号" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                <Size X="98.0000" Y="42.0000" />
                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                <Position X="-450.0000" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="140" G="63" B="1" />
                <PrePosition />
                <PreSize X="0.0000" Y="0.0000" />
                <FontResource Type="Normal" Path="fonts/DroidDefault.ttf" Plist="" />
                <OutlineColor A="255" R="255" G="0" B="0" />
                <ShadowColor A="255" R="110" G="110" B="110" />
              </AbstractNodeData>
              <AbstractNodeData Name="Text_createTime" ActionTag="-73729112" Tag="93" IconVisible="False" LeftMargin="-284.0000" RightMargin="156.0000" TopMargin="-21.0000" BottomMargin="-21.0000" FontSize="32" LabelText="创建时间" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                <Size X="128.0000" Y="42.0000" />
                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                <Position X="-220.0000" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="140" G="63" B="1" />
                <PrePosition />
                <PreSize X="0.0000" Y="0.0000" />
                <FontResource Type="Normal" Path="fonts/DroidDefault.ttf" Plist="" />
                <OutlineColor A="255" R="255" G="0" B="0" />
                <ShadowColor A="255" R="110" G="110" B="110" />
              </AbstractNodeData>
              <AbstractNodeData Name="Text_player" ActionTag="1178527922" Tag="94" IconVisible="False" LeftMargin="-32.5000" RightMargin="-32.5000" TopMargin="-21.0000" BottomMargin="-21.0000" FontSize="32" LabelText="玩家" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                <Size X="65.0000" Y="42.0000" />
                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                <Position />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="140" G="63" B="1" />
                <PrePosition />
                <PreSize X="0.0000" Y="0.0000" />
                <FontResource Type="Normal" Path="fonts/DroidDefault.ttf" Plist="" />
                <OutlineColor A="255" R="255" G="0" B="0" />
                <ShadowColor A="255" R="110" G="110" B="110" />
              </AbstractNodeData>
              <AbstractNodeData Name="Text_state" ActionTag="-1097886598" Tag="159" IconVisible="False" LeftMargin="147.0000" RightMargin="-213.0000" TopMargin="-21.0000" BottomMargin="-21.0000" FontSize="32" LabelText="状态" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                <Size X="66.0000" Y="42.0000" />
                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                <Position X="180.0000" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="140" G="63" B="1" />
                <PrePosition />
                <PreSize X="0.0000" Y="0.0000" />
                <FontResource Type="Normal" Path="fonts/DroidDefault.ttf" Plist="" />
                <OutlineColor A="255" R="255" G="0" B="0" />
                <ShadowColor A="255" R="110" G="110" B="110" />
              </AbstractNodeData>
              <AbstractNodeData Name="Text_operation" ActionTag="-816298815" Tag="95" IconVisible="False" LeftMargin="367.0000" RightMargin="-433.0000" TopMargin="-21.0000" BottomMargin="-21.0000" FontSize="32" LabelText="操作" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                <Size X="66.0000" Y="42.0000" />
                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                <Position X="400.0000" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="140" G="63" B="1" />
                <PrePosition />
                <PreSize X="0.0000" Y="0.0000" />
                <FontResource Type="Normal" Path="fonts/DroidDefault.ttf" Plist="" />
                <OutlineColor A="255" R="255" G="0" B="0" />
                <ShadowColor A="255" R="110" G="110" B="110" />
              </AbstractNodeData>
            </Children>
            <AnchorPoint />
            <Position X="641.0132" Y="591.1433" />
            <Scale ScaleX="1.0000" ScaleY="1.0000" />
            <CColor A="255" R="255" G="255" B="255" />
            <PrePosition X="0.5008" Y="0.8210" />
            <PreSize X="0.0000" Y="0.0000" />
          </AbstractNodeData>
          <AbstractNodeData Name="lvRoom" ActionTag="141142430" Tag="97" IconVisible="False" LeftMargin="62.1128" RightMargin="57.8872" TopMargin="148.5500" BottomMargin="91.4500" TouchEnable="True" ClipAble="True" BackColorAlpha="0" ComboBoxIndex="1" ColorAngle="90.0000" Scale9Width="1" Scale9Height="1" IsBounceEnabled="True" ScrollDirectionType="0" ItemMargin="2" DirectionType="Vertical" HorizontalType="Align_HorizontalCenter" ctype="ListViewObjectData">
            <Size X="1160.0000" Y="480.0000" />
            <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
            <Position X="642.1128" Y="331.4500" />
            <Scale ScaleX="1.0000" ScaleY="1.0000" />
            <CColor A="255" R="255" G="255" B="255" />
            <PrePosition X="0.5017" Y="0.4603" />
            <PreSize X="0.9063" Y="0.6667" />
            <SingleColor A="255" R="150" G="150" B="255" />
            <FirstColor A="255" R="150" G="150" B="255" />
            <EndColor A="255" R="255" G="255" B="255" />
            <ColorVector ScaleY="1.0000" />
          </AbstractNodeData>
          <AbstractNodeData Name="txtEmpty" ActionTag="11619039" Tag="351" IconVisible="False" LeftMargin="389.5000" RightMargin="389.5000" TopMargin="347.5000" BottomMargin="307.5000" FontSize="50" LabelText="暂时没有任何代开记录" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
            <Size X="501.0000" Y="65.0000" />
            <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
            <Position X="640.0000" Y="340.0000" />
            <Scale ScaleX="1.0000" ScaleY="1.0000" />
            <CColor A="255" R="93" G="13" B="4" />
            <PrePosition X="0.5000" Y="0.4722" />
            <PreSize X="0.3914" Y="0.0903" />
            <FontResource Type="Normal" Path="fonts/DroidDefault.ttf" Plist="" />
            <OutlineColor A="255" R="255" G="0" B="0" />
            <ShadowColor A="255" R="110" G="110" B="110" />
          </AbstractNodeData>
          <AbstractNodeData Name="btnExit" ActionTag="-834566311" Tag="1015" IconVisible="False" LeftMargin="1189.9993" RightMargin="8.0007" TopMargin="11.0005" BottomMargin="625.9995" TouchEnable="True" FontSize="14" Scale9Enable="True" LeftEage="15" RightEage="15" TopEage="11" BottomEage="11" Scale9OriginX="15" Scale9OriginY="11" Scale9Width="52" Scale9Height="61" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="ButtonObjectData">
            <Size X="82.0000" Y="83.0000" />
            <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
            <Position X="1230.9993" Y="667.4995" />
            <Scale ScaleX="1.0000" ScaleY="1.0000" />
            <CColor A="255" R="255" G="255" B="255" />
            <PrePosition X="0.9617" Y="0.9271" />
            <PreSize X="0.0641" Y="0.1153" />
            <TextColor A="255" R="65" G="65" B="70" />
            <NormalFileData Type="MarkedSubImage" Path="Image/GComm/comm_btn_close.png" Plist="Texture/GComm.plist" />
            <OutlineColor A="255" R="255" G="0" B="0" />
            <ShadowColor A="255" R="110" G="110" B="110" />
          </AbstractNodeData>
        </Children>
      </ObjectData>
    </Content>
  </Content>
</GameFile>