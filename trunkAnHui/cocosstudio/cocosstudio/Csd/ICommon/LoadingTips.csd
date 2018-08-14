<GameFile>
  <PropertyGroup Name="LoadingTips" Type="Node" ID="8227f8f4-5cae-4790-8128-16032932ccc2" Version="3.10.0.0" />
  <Content ctype="GameProjectContent">
    <Content>
      <Animation Duration="120" Speed="1.0000">
        <Timeline ActionTag="2112911911" Property="RotationSkew">
          <ScaleFrame FrameIndex="0" X="0.0000" Y="0.0000">
            <EasingData Type="0" />
          </ScaleFrame>
          <ScaleFrame FrameIndex="120" X="360.0000" Y="360.0000">
            <EasingData Type="0" />
          </ScaleFrame>
        </Timeline>
      </Animation>
      <ObjectData Name="Node" Tag="18" ctype="GameNodeObjectData">
        <Size X="0.0000" Y="0.0000" />
        <Children>
          <AbstractNodeData Name="imgBG" ActionTag="-2031556060" Tag="22" IconVisible="False" LeftMargin="-250.0000" RightMargin="-250.0000" TopMargin="-175.0000" BottomMargin="-175.0000" Scale9Enable="True" LeftEage="80" RightEage="80" TopEage="70" BottomEage="70" Scale9OriginX="80" Scale9OriginY="70" Scale9Width="6" Scale9Height="8" ctype="ImageViewObjectData">
            <Size X="500.0000" Y="350.0000" />
            <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
            <Position />
            <Scale ScaleX="1.0000" ScaleY="1.0000" />
            <CColor A="255" R="255" G="255" B="255" />
            <PrePosition />
            <PreSize X="0.0000" Y="0.0000" />
            <FileData Type="MarkedSubImage" Path="Image/GComm/comm_bg_loading.png" Plist="Texture/GComm.plist" />
          </AbstractNodeData>
          <AbstractNodeData Name="imgCircle" ActionTag="2112911911" Tag="21" IconVisible="False" LeftMargin="-40.1543" RightMargin="-32.8457" TopMargin="-86.2265" BottomMargin="7.2265" FlipX="True" ctype="SpriteObjectData">
            <Size X="73.0000" Y="79.0000" />
            <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
            <Position X="-3.6543" Y="46.7265" />
            <Scale ScaleX="1.5000" ScaleY="1.5000" />
            <CColor A="255" R="255" G="255" B="255" />
            <PrePosition />
            <PreSize X="0.0000" Y="0.0000" />
            <FileData Type="MarkedSubImage" Path="Image/GComm/comm_icon_white_circle.png" Plist="Texture/GComm.plist" />
            <BlendFunc Src="1" Dst="771" />
          </AbstractNodeData>
          <AbstractNodeData Name="img" ActionTag="2030480705" Tag="20" IconVisible="False" LeftMargin="-23.3925" RightMargin="-10.6075" TopMargin="-61.5172" BottomMargin="27.5172" LeftEage="11" RightEage="11" TopEage="11" BottomEage="11" Scale9OriginX="11" Scale9OriginY="11" Scale9Width="12" Scale9Height="12" ctype="ImageViewObjectData">
            <Size X="34.0000" Y="34.0000" />
            <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
            <Position X="-6.3925" Y="44.5172" />
            <Scale ScaleX="1.0000" ScaleY="1.0000" />
            <CColor A="255" R="255" G="255" B="255" />
            <PrePosition />
            <PreSize X="0.0000" Y="0.0000" />
            <FileData Type="MarkedSubImage" Path="Image/GComm/comm_icon_shaizi.png" Plist="Texture/GComm.plist" />
          </AbstractNodeData>
          <AbstractNodeData Name="txtTips" ActionTag="869350363" Tag="19" IconVisible="False" LeftMargin="-205.7388" RightMargin="-219.2612" TopMargin="50.4137" BottomMargin="-118.4137" IsCustomSize="True" FontSize="30" LabelText="正在努力加载中..." HorizontalAlignmentType="HT_Center" VerticalAlignmentType="VT_Center" ShadowOffsetX="2.0000" ShadowOffsetY="-2.0000" ctype="TextObjectData">
            <Size X="425.0000" Y="68.0000" />
            <AnchorPoint ScaleX="0.5000" ScaleY="0.5000" />
            <Position X="6.7612" Y="-84.4137" />
            <Scale ScaleX="1.0000" ScaleY="1.0000" />
            <CColor A="255" R="102" G="38" B="0" />
            <PrePosition />
            <PreSize X="0.0000" Y="0.0000" />
            <OutlineColor A="255" R="255" G="0" B="0" />
            <ShadowColor A="255" R="102" G="38" B="0" />
          </AbstractNodeData>
        </Children>
      </ObjectData>
    </Content>
  </Content>
</GameFile>