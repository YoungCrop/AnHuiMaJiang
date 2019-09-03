<GameFile>
  <PropertyGroup Name="ServerDebug" Type="Node" ID="835f98dc-1cd0-4a7b-92e2-e2a5c748dd90" Version="3.10.0.0" />
  <Content ctype="GameProjectContent">
    <Content>
      <Animation Duration="0" Speed="1.0000" />
      <ObjectData Name="Node" Tag="7588" ctype="GameNodeObjectData">
        <Size X="0.0000" Y="0.0000" />
        <Children>
          <AbstractNodeData Name="layoutRoot" ActionTag="141151037" Tag="741" IconVisible="False" LeftMargin="-450.0000" RightMargin="-450.0000" TopMargin="-340.0000" BottomMargin="-340.0000" TouchEnable="True" ClipAble="False" ComboBoxIndex="1" ColorAngle="90.0000" Scale9Width="1" Scale9Height="1" ctype="PanelObjectData">
            <Size X="900.0000" Y="680.0000" />
            <Children>
              <AbstractNodeData Name="txtTitle" ActionTag="-540312735" Tag="7599" IconVisible="False" PositionPercentXEnabled="True" PositionPercentYEnabled="True" LeftMargin="360.0000" RightMargin="360.0000" BottomMargin="628.0000" FontSize="45" LabelText="消息调试" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                <Size X="180.0000" Y="52.0000" />
                <AnchorPoint ScaleX="0.5000" ScaleY="1.0000" />
                <Position X="450.0000" Y="680.0000" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="0" B="0" />
                <PrePosition X="0.5000" Y="1.0000" />
                <PreSize X="0.2000" Y="0.0765" />
                <OutlineColor A="255" R="255" G="0" B="0" />
                <ShadowColor A="255" R="110" G="110" B="110" />
              </AbstractNodeData>
              <AbstractNodeData Name="txtSendMsgNo" ActionTag="175468135" Tag="748" IconVisible="False" LeftMargin="0.0001" RightMargin="719.9999" TopMargin="80.8354" BottomMargin="565.1646" FontSize="30" LabelText="发送消息号：" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                <Size X="180.0000" Y="34.0000" />
                <Children>
                  <AbstractNodeData Name="tfSendMsgNo" ActionTag="-1100597115" Tag="750" IconVisible="False" PositionPercentYEnabled="True" LeftMargin="176.5199" RightMargin="-196.5199" TouchEnable="True" FontSize="30" IsCustomSize="True" LabelText="" PlaceHolderText="发送给服务器端的消息号" MaxLengthText="10" ctype="TextFieldObjectData">
                    <Size X="200.0000" Y="34.0000" />
                    <AnchorPoint ScaleY="0.5000" />
                    <Position X="176.5199" Y="17.0000" />
                    <Scale ScaleX="1.0000" ScaleY="1.0000" />
                    <CColor A="255" R="165" G="42" B="42" />
                    <PrePosition X="0.9807" Y="0.5000" />
                    <PreSize X="1.1111" Y="1.0000" />
                  </AbstractNodeData>
                </Children>
                <AnchorPoint ScaleY="0.5000" />
                <Position X="0.0001" Y="582.1646" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="192" B="203" />
                <PrePosition X="0.0000" Y="0.8561" />
                <PreSize X="0.2000" Y="0.0500" />
                <OutlineColor A="255" R="255" G="0" B="0" />
                <ShadowColor A="255" R="110" G="110" B="110" />
              </AbstractNodeData>
              <AbstractNodeData Name="txtBackMsgNo" ActionTag="621579805" Tag="749" IconVisible="False" LeftMargin="412.3225" RightMargin="307.6775" TopMargin="80.8354" BottomMargin="565.1646" FontSize="30" LabelText="返回消息号：" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                <Size X="180.0000" Y="34.0000" />
                <Children>
                  <AbstractNodeData Name="tfBackMsgNo" ActionTag="-470659887" Tag="751" IconVisible="False" PositionPercentYEnabled="True" LeftMargin="176.5192" RightMargin="-196.5192" TouchEnable="True" FontSize="30" IsCustomSize="True" LabelText="" PlaceHolderText="接收服务器端发来的消息号" MaxLengthText="10" ctype="TextFieldObjectData">
                    <Size X="200.0000" Y="34.0000" />
                    <AnchorPoint ScaleY="0.5000" />
                    <Position X="176.5192" Y="17.0000" />
                    <Scale ScaleX="1.0000" ScaleY="1.0000" />
                    <CColor A="255" R="165" G="42" B="42" />
                    <PrePosition X="0.9807" Y="0.5000" />
                    <PreSize X="1.1111" Y="1.0000" />
                  </AbstractNodeData>
                </Children>
                <AnchorPoint ScaleY="0.5000" />
                <Position X="412.3225" Y="582.1646" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="192" B="203" />
                <PrePosition X="0.4581" Y="0.8561" />
                <PreSize X="0.2000" Y="0.0500" />
                <OutlineColor A="255" R="255" G="0" B="0" />
                <ShadowColor A="255" R="110" G="110" B="110" />
              </AbstractNodeData>
              <AbstractNodeData Name="txtSendMsgParam" ActionTag="-1875363125" Tag="752" IconVisible="False" LeftMargin="0.0001" RightMargin="689.9999" TopMargin="133.3644" BottomMargin="512.6356" FontSize="30" LabelText="发送消息参数：" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                <Size X="210.0000" Y="34.0000" />
                <Children>
                  <AbstractNodeData Name="tfSendMsgParam" ActionTag="-1891454271" Tag="753" IconVisible="False" RightMargin="-490.0000" TopMargin="41.3463" BottomMargin="-67.3463" TouchEnable="True" FontSize="30" IsCustomSize="True" LabelText="" PlaceHolderText="参数列表，用逗号隔开" MaxLengthText="10" ctype="TextFieldObjectData">
                    <Size X="700.0000" Y="60.0000" />
                    <AnchorPoint ScaleY="0.5000" />
                    <Position Y="-37.3463" />
                    <Scale ScaleX="1.0000" ScaleY="1.0000" />
                    <CColor A="255" R="165" G="42" B="42" />
                    <PrePosition Y="-1.0984" />
                    <PreSize X="3.3333" Y="1.7647" />
                  </AbstractNodeData>
                </Children>
                <AnchorPoint ScaleY="0.5000" />
                <Position X="0.0001" Y="529.6356" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="192" B="203" />
                <PrePosition X="0.0000" Y="0.7789" />
                <PreSize X="0.2333" Y="0.0500" />
                <OutlineColor A="255" R="255" G="0" B="0" />
                <ShadowColor A="255" R="110" G="110" B="110" />
              </AbstractNodeData>
              <AbstractNodeData Name="txtBackMsg" ActionTag="-1593678429" Tag="917" IconVisible="False" RightMargin="750.0000" TopMargin="235.0715" BottomMargin="410.9285" FontSize="30" LabelText="返回消息体" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                <Size X="150.0000" Y="34.0000" />
                <Children>
                  <AbstractNodeData Name="svBackMsg" ActionTag="-571199121" Tag="9062" IconVisible="False" RightMargin="-750.0000" TopMargin="44.0000" BottomMargin="-410.0000" TouchEnable="True" ClipAble="True" BackColorAlpha="102" ComboBoxIndex="1" ColorAngle="90.0000" Scale9Width="1" Scale9Height="1" ScrollDirectionType="Vertical" ctype="ScrollViewObjectData">
                    <Size X="900.0000" Y="400.0000" />
                    <Children>
                      <AbstractNodeData Name="txtBackMsg" ActionTag="409470180" Tag="7591" IconVisible="False" PositionPercentXEnabled="True" PositionPercentYEnabled="True" BottomMargin="500.0000" IsCustomSize="True" FontSize="34" LabelText="亲爱的玩家，建议您选择微信登录。游客模式下的游戏数据在更换设备时将无法找回，确定登录吗?" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
                        <Size X="900.0000" Y="400.0000" />
                        <AnchorPoint ScaleX="0.5000" ScaleY="1.0000" />
                        <Position X="450.0000" Y="900.0000" />
                        <Scale ScaleX="1.0000" ScaleY="1.0000" />
                        <CColor A="255" R="102" G="38" B="0" />
                        <PrePosition X="0.5000" Y="1.0000" />
                        <PreSize X="1.0000" Y="0.4444" />
                        <OutlineColor A="255" R="255" G="0" B="0" />
                        <ShadowColor A="255" R="110" G="110" B="110" />
                      </AbstractNodeData>
                    </Children>
                    <AnchorPoint ScaleY="1.0000" />
                    <Position Y="-10.0000" />
                    <Scale ScaleX="1.0000" ScaleY="1.0000" />
                    <CColor A="255" R="255" G="255" B="255" />
                    <PrePosition Y="-0.2941" />
                    <PreSize X="6.0000" Y="11.7647" />
                    <SingleColor A="255" R="191" G="191" B="191" />
                    <FirstColor A="255" R="255" G="150" B="100" />
                    <EndColor A="255" R="255" G="255" B="255" />
                    <ColorVector ScaleY="1.0000" />
                    <InnerNodeSize Width="900" Height="900" />
                  </AbstractNodeData>
                </Children>
                <AnchorPoint ScaleY="0.5000" />
                <Position Y="427.9285" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="192" B="203" />
                <PrePosition Y="0.6293" />
                <PreSize X="0.1667" Y="0.0500" />
                <OutlineColor A="255" R="255" G="0" B="0" />
                <ShadowColor A="255" R="110" G="110" B="110" />
              </AbstractNodeData>
              <AbstractNodeData Name="btnSend" ActionTag="21762820" Tag="754" IconVisible="False" LeftMargin="684.9124" RightMargin="75.0876" TopMargin="126.9628" BottomMargin="503.0372" TouchEnable="True" FontSize="30" ButtonText="发送" Scale9Enable="True" LeftEage="15" RightEage="15" TopEage="11" BottomEage="11" Scale9OriginX="15" Scale9OriginY="11" Scale9Width="16" Scale9Height="14" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="ButtonObjectData">
                <Size X="140.0000" Y="50.0000" />
                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                <Position X="754.9124" Y="528.0372" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition X="0.8388" Y="0.7765" />
                <PreSize X="0.1556" Y="0.0735" />
                <TextColor A="255" R="65" G="65" B="70" />
                <DisabledFileData Type="Default" Path="Default/Button_Disable.png" Plist="" />
                <PressedFileData Type="Default" Path="Default/Button_Press.png" Plist="" />
                <NormalFileData Type="Default" Path="Default/Button_Normal.png" Plist="" />
                <OutlineColor A="255" R="255" G="0" B="0" />
                <ShadowColor A="255" R="110" G="110" B="110" />
              </AbstractNodeData>
              <AbstractNodeData Name="btnClose" ActionTag="-683703871" Tag="916" IconVisible="False" LeftMargin="830.8613" RightMargin="-0.8613" TopMargin="0.9224" BottomMargin="629.0776" TouchEnable="True" FontSize="30" ButtonText="关闭" Scale9Enable="True" LeftEage="15" RightEage="15" TopEage="11" BottomEage="11" Scale9OriginX="15" Scale9OriginY="11" Scale9Width="16" Scale9Height="14" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="ButtonObjectData">
                <Size X="70.0000" Y="50.0000" />
                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                <Position X="865.8613" Y="654.0776" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition X="0.9621" Y="0.9619" />
                <PreSize X="0.0778" Y="0.0735" />
                <TextColor A="255" R="65" G="65" B="70" />
                <DisabledFileData Type="Default" Path="Default/Button_Disable.png" Plist="" />
                <PressedFileData Type="Default" Path="Default/Button_Press.png" Plist="" />
                <NormalFileData Type="Default" Path="Default/Button_Normal.png" Plist="" />
                <OutlineColor A="255" R="255" G="0" B="0" />
                <ShadowColor A="255" R="110" G="110" B="110" />
              </AbstractNodeData>
            </Children>
            <AnchorPoint />
            <Position X="-450.0000" Y="-340.0000" />
            <Scale ScaleX="1.0000" ScaleY="1.0000" />
            <CColor A="255" R="255" G="255" B="255" />
            <PrePosition />
            <PreSize X="0.0000" Y="0.0000" />
            <SingleColor A="255" R="0" G="0" B="0" />
            <FirstColor A="255" R="150" G="200" B="255" />
            <EndColor A="255" R="255" G="255" B="255" />
            <ColorVector ScaleY="1.0000" />
          </AbstractNodeData>
        </Children>
      </ObjectData>
    </Content>
  </Content>
</GameFile>