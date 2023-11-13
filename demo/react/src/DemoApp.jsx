import React, { useState } from 'react';

const { LiterallyCanvasReactComponent } = window.LC;

const DemoApp = () => {
  // Initialize state using useState hook
  const [isSetUp, setIsSetUp] = useState(true);
  const [svgText, setSvgText] = useState("");
  const [lc, setLc] = useState(null);

  const backgroundImage = new Image();
  backgroundImage.src = '/demo/resources/bear.png';

  const handleInit = (lcInstance) => {
    setLc(lcInstance);
    const watermarkImage = new Image();
    watermarkImage.src = '/demo/resources/watermark.png';
    lcInstance.setWatermarkImage(watermarkImage);

    lcInstance.on('drawingChange', save);
    lcInstance.on('pan', save);
    lcInstance.on('zoom', save);
    save();
  };

  // Define lcOptions outside of useEffect
  const lcOptions = {
    backgroundImage: backgroundImage,
    toolbarPosition: 'bottom',
    snapshot: JSON.parse(localStorage.getItem('drawing')),
    backgroundShapes: [
      LC.createShape(
        'Image', { image: backgroundImage, x: 100, y: 100, scale: 2 }),
      LC.createShape(
        'Rectangle',
        { x: 0, y: 0, width: 100, height: 100, strokeColor: '#000' })
    ],
    onInit: handleInit,
    imageURLPrefix: "/lib/img"
  };

  function save() {
    if (lc) {
      localStorage.setItem('drawing', JSON.stringify(lc.getSnapshot()));
      setSvgText(lc.getSVGString());
    }
  }

  const actionOpenImage = () => {
    window.open(lc.getImage({
      // rect: {x: 0, y: 0, width: 100, height: 100}
      scale: 1, margin: { top: 10, right: 10, bottom: 10, left: 10 }
    }).toDataURL());
  };

  const actionChangeSize = () => {
    lc.setImageSize(null, 200);
  };

  const actionSetUp = () => {
    setIsSetUp(true);
  };

  const actionTearDown = () => {
    setIsSetUp(false);
  };

  return (
    <div>
      {isSetUp && <LiterallyCanvasReactComponent {...lcOptions} />}
      <a onClick={actionOpenImage}>open image</a><br />
      <a onClick={actionChangeSize}>change size</a><br />
      {isSetUp && <a onClick={actionTearDown}>teardown</a>}
      {!isSetUp && <a onClick={actionSetUp}>setup</a>}
      <br />
      <div className="svg-container" dangerouslySetInnerHTML={{ __html: svgText }} />
    </div>
  );
};

export default DemoApp;