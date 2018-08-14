<GameFile>
  <PropertyGroup Name="ItemCoinExchange" Type="Layer" ID="e8d88aa4-e266-4863-890a-f55ea519746a" Version="3.10.0.0" />
  <Content ctype="GameProjectContent">
    <Content>
      <Animation Duration="0" Speed="1.0000" />
      <ObjectData Name="Layer" Tag="10334" ctype="GameLayerObjectData">
        <Size X="210.0000" Y="250.0000" />
        <Children>
          <AbstractNodeData Name="btnBG" ActionTag="-280436878" Tag="556" IconVisible="False" PositionPercentXEnabled="True" PositionPercentYEnabled="True" TouchEnable="True" FontSize="14" Scale9Enable="True" LeftEage="15" RightEage="15" TopEage="11" BottomEage="11" Scale9OriginX="15" Scale9OriginY="11" Scale9Width="242" Scale9Height="302" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="ButtonObjectData">
            <Size X="210.0000" Y="250.0000" />
            <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
            <Position X="105.0000" Y="125.0000" />
            <Scale ScaleX="1.0000" ScaleY="1.0000" />
            <CColor A="255" R="255" G="255" B="255" />
            <PrePosition X="0.5000" Y="0.5000" />
            <PreSize X="1.0000" Y="1.0000" />
            <TextColor A="255" R="65" G="65" B="70" />
            <PressedFileData Type="MarkedSubImage" Path="Image/ILobby/UIShop/shop_bg_item.png" Plist="Texture/ILobby/UIShop.plist" />
            <NormalFileData Type="MarkedSubImage" Path="Image/ILobby/UIShop/shop_bg_item.png" Plist="Texture/ILobby/UIShop.plist" />
            <OutlineColor A="255" R="255" G="0" B="0" />
            <ShadowColor A="255" R="110" G="110" B="110" />
          </AbstractNodeData>
          <AbstractNodeData Name="spriteSelected" ActionTag="954834847" VisibleForFrame="False" Tag="557" IconVisible="False" PositionPercentXEnabled="True" PositionPercentYEnabled="True" LeftMargin="-47.5000" RightMargin="-47.5000" TopMargin="-47.5750" BottomMargin="-41.4250" ctype="SpriteObjectData">
            <Size X="305.0000" Y="339.0000" />
            <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
            <Position X="105.0000" Y="128.0750" />
            <Scale ScaleX="0.9500" ScaleY="1.0000" />
            <CColor A="255" R="255" G="255" B="255" />
            <PrePosition X="0.5000" Y="0.5123" />
            <PreSize X="1.4524" Y="1.3560" />
            <FileData Type="MarkedSubImage" Path="Image/ILobby/UIShop/shop_item_select.png" Plist="Texture/ILobby/UIShop.plist" />
            <BlendFunc Src="1" Dst="771" />
          </AbstractNodeData>
          <AbstractNodeData Name="iconCoin" ActionTag="-2081598670" Tag="558" IconVisible="False" PositionPercentXEnabled="True" PositionPercentYEnabled="True" LeftMargin="62.5000" RightMargin="62.5000" TopMargin="90.0000" BottomMargin="90.0000" ctype="SpriteObjectData">
            <Size X="85.0000" Y="70.0000" />
            <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
            <Position X="105.0000" Y="125.0000" />
            <Scale ScaleX="1.0000" ScaleY="1.0000" />
            <CColor A="255" R="255" G="255" B="255" />
            <PrePosition X="0.5000" Y="0.5000" />
            <PreSize X="0.4048" Y="0.2800" />
            <FileData Type="MarkedSubImage" Path="Image/ILobby/UICoin/Coin_exchange_4.png" Plist="Texture/ILobby/UICoin.plist" />
            <BlendFunc Src="1" Dst="771" />
          </AbstractNodeData>
          <AbstractNodeData Name="txtCoin" ActionTag="-2109244246" Tag="560" IconVisible="False" PositionPercentXEnabled="True" PositionPercentYEnabled="True" LeftMargin="28.0000" RightMargin="28.0000" BottomMargin="208.0000" FontSize="32" LabelText="12000金币" ShadowOffsetX="0.5000" ShadowOffsetY="0.5000" ShadowEnabled="True" ctype="TextObjectData">
            <Size X="154.0000" Y="42.0000" />
            <AnchorPoint ScaleX="0.5000" ScaleY="1.0000" />
            <Position X="105.0000" Y="250.0000" />
            <Scale ScaleX="1.0000" ScaleY="1.0000" />
            <CColor A="255" R="255" G="255" B="255" />
            <PrePosition X="0.5000" Y="1.0000" />
            <PreSize X="0.7333" Y="0.1680" />
            <FontResource Type="Normal" Path="fonts/DroidDefault.ttf" Plist="" />
            <OutlineColor A="255" R="255" G="0" B="0" />
            <ShadowColor A="255" R="255" G="255" B="255" />
          </AbstractNodeData>
          <AbstractNodeData Name="imgCardBG" ActionTag="-1012916036" Tag="562" IconVisible="False" PositionPercentXEnabled="True" LeftMargin="5.0000" RightMargin="5.0000" TopMargin="193.0000" BottomMargin="6.0000" Scale9Enable="True" LeftEage="47" RightEage="47" TopEage="16" BottomEage="16" Scale9OriginX="47" Scale9OriginY="16" Scale9Width="49" Scale9Height="19" ctype="ImageViewObjectData">
            <Size X="200.0000" Y="51.0000" />
            <Children>
              <AbstractNodeData Name="txtCard" ActionTag="-1364155704" Tag="559" IconVisible="False" PositionPercentXEnabled="True" LeftMargin="71.0200" RightMargin="46.9800" TopMargin="5.3886" BottomMargin="3.6114" FontSize="32" LabelText="X 100" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ShadowEnabled="True" ctype="TextObjectData">
                <Size X="82.0000" Y="42.0000" />
                <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
                <Position X="112.0200" Y="24.6114" />
                <Scale ScaleX="1.0000" ScaleY="1.0000" />
                <CColor A="255" R="255" G="255" B="255" />
                <PrePosition X="0.5601" Y="0.4826" />
                <PreSize X="0.4100" Y="0.8235" />
                <FontResource Type="Normal" Path="fonts/DroidDefault.ttf" Plist="" />
                <OutlineColor A="255" R="74" G="39" B="15" />
                <ShadowColor A="255" R="255" G="0" B="0" />
              </AbstractNodeData>
            </Children>
            <AnchorPoint ScaleX="0.5000" />
            <Position X="105.0000" Y="6.0000" />
            <Scale ScaleX="1.0000" ScaleY="1.0000" />
            <CColor A="255" R="255" G="255" B="255" />
            <PrePosition X="0.5000" Y="0.0240" />
            <PreSize X="0.9524" Y="0.2040" />
            <FileData Type="MarkedSubImage" Path="Image/ILobby/UICoin/Coin_btn_exchange.png" Plist="Texture/ILobby/UICoin.plist" />
          </AbstractNodeData>
        </Children>
      </ObjectData>
    </Content>
  </Content>
</GameFile>