export const NEST_ROOM_1_SOURCE_MAP = Object.freeze({
  id: "nestRoom1",
  family: "nest",
  sourceSwf: "nestRoom1.swf",
  localReferenceRoot: "reference/rooms/nest-dump/nestRoom1.swf",
  localXmlPath: "reference/rooms/nest-dump/SWF XML/nestRoom1.xml",

  stage: {
    width: 614,
    height: 366,
    twipsPerPixel: 20
  },

  root: {
    className: "nestRoom1_fla.MainTimeline",
    symbolId: 0,
    exposedChildren: ["door1_mc", "roomBG_spr"]
  },

  symbols: {
    roomBG_spr: {
      characterId: 5,
      depth: 1,
      matrix: {
        scaleX: -1.0,
        scaleY: 1.0,
        translateXTwips: 6170,
        translateYTwips: 4111,
        translateXPixels: 308.5,
        translateYPixels: 205.55
      }
    },

    door1_mc: {
      characterId: 12,
      depth: 11,
      className: "nestRoom1_fla.door_side_3",
      matrix: {
        scaleX: -1.0,
        scaleY: 1.0,
        translateXTwips: 11079,
        translateYTwips: 4608,
        translateXPixels: 553.95,
        translateYPixels: 230.4
      }
    },

    mask1_spr: {
      characterId: 7,
      depth: 1,
      matrix: {
        scaleX: 1.029129,
        scaleY: 1.029129,
        translateXTwips: -802,
        translateYTwips: -1017,
        translateXPixels: -40.1,
        translateYPixels: -50.85
      }
    },

    mask2_spr: {
      characterId: 7,
      depth: 3,
      matrix: {
        scaleX: 1.029129,
        scaleY: 1.029129,
        translateXTwips: -802,
        translateYTwips: -1017,
        translateXPixels: -40.1,
        translateYPixels: -50.85
      }
    },

    mask3_spr: {
      characterId: 7,
      depth: 5,
      matrix: {
        scaleX: 1.029129,
        scaleY: 1.029129,
        translateXTwips: -802,
        translateYTwips: -1017,
        translateXPixels: -40.1,
        translateYPixels: -50.85
      }
    },

    clickArea_btn: {
      characterId: 11,
      depth: 9,
      matrix: {
        scaleX: 1.029129,
        scaleY: 1.029129,
        translateXTwips: -279,
        translateYTwips: -396,
        translateXPixels: -13.95,
        translateYPixels: -19.8
      }
    }
  },

  next: [
    "build-nest-room-1-source-map-smoke-test",
    "build-preview-probe-from-frames-1-png",
    "then-build-source-backed-room-composition"
  ]
});
