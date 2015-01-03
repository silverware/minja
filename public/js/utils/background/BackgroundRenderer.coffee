define ['threejs', 'jquery'], ->

  ###--------------------------------------------------------------------------
     SHADER
    --------------------------------------------------------------------------###

  VERTEX_SHADER = """
    uniform sampler2D heightmap;
    varying vec2 planePosition;
    void main() {
      vec4 newPosition = modelMatrix * vec4(position, 1.0);
      planePosition = vec2(newPosition.x / 1000.0 + 0.5, newPosition.z / 300.0 + 0.5);
      newPosition.y += texture2D(heightmap, planePosition).x * 120.0 - 60.0;
      gl_Position = projectionMatrix * viewMatrix * newPosition;
    }
  """

  FRAGMENT_SHADER = """
    uniform sampler2D heightmap;
    varying vec2 planePosition;
    void main() {
      float color = texture2D(heightmap, planePosition).x;
      float deltaY = planePosition.y + 0.01;
      float deltaZ, color2;
      if (deltaY > 1.0) {
        color2 = texture2D(heightmap, vec2(planePosition.x, planePosition.y - 0.01)).x;
        deltaZ =  (color - color2) * 1.29;
      } else {
        color2 = texture2D(heightmap, vec2(planePosition.x, deltaY)).x;
        deltaZ = (color2 - color) * 1.29;
      }
      gl_FragColor = vec4(deltaZ * 9.0 + 0.14);
    }
  """

  HEIGHT_VERTEX_SHADER = """
    void main() {
      gl_Position = vec4(position, 1.0);
    }
  """

  HEIGHT_FRAGMENT_SHADER = """
    vec3 mod289(vec3 x) {
      return x - floor(x * (1.0 / 289.0)) * 289.0;
    }

    vec2 mod289(vec2 x) {
      return x - floor(x * (1.0 / 289.0)) * 289.0;
    }

    vec3 permute(vec3 x) {
      return mod289(((x*34.0)+1.0)*x);
    }

    float snoise(vec2 v)
      {
      const vec4 C = vec4(0.211324865405187, // (3.0-sqrt(3.0))/6.0
                          0.366025403784439, // 0.5*(sqrt(3.0)-1.0)
                         -0.577350269189626, // -1.0 + 2.0 * C.x
                          0.024390243902439); // 1.0 / 41.0
      vec2 i = floor(v + dot(v, C.yy) );
      vec2 x0 = v - i + dot(i, C.xx);

      vec2 i1;
      //i1.x = step( x0.y, x0.x ); // x0.x > x0.y ? 1.0 : 0.0
      //i1.y = 1.0 - i1.x;
      i1 = (x0.x > x0.y) ? vec2(1.0, 0.0) : vec2(0.0, 1.0);
      // x0 = x0 - 0.0 + 0.0 * C.xx ;
      // x1 = x0 - i1 + 1.0 * C.xx ;
      // x2 = x0 - 1.0 + 2.0 * C.xx ;
      vec4 x12 = x0.xyxy + C.xxzz;
      x12.xy -= i1;
      i = mod289(i); // Avoid truncation effects in permutation
      vec3 p = permute( permute( i.y + vec3(0.0, i1.y, 1.0 ))
    + i.x + vec3(0.0, i1.x, 1.0 ));

      vec3 m = max(0.5 - vec3(dot(x0,x0), dot(x12.xy,x12.xy), dot(x12.zw,x12.zw)), 0.0);
      m = m*m ;
      m = m*m ;

      vec3 x = 2.0 * fract(p * C.www) - 1.0;
      vec3 h = abs(x) - 0.5;
      vec3 ox = floor(x + 0.5);
      vec3 a0 = x - ox;

      m *= 1.79284291400159 - 0.85373472095314 * ( a0*a0 + h*h );

      vec3 g;
      g.x = a0.x * x0.x + h.x * x0.y;
      g.yz = a0.yz * x12.xz + h.yz * x12.yw;
      return 130.0 * dot(m, g);
    }



    uniform float time;

    const float resolution = 512.0;
    const float TAU = 6.283185;

    void main() {
      vec2 position = gl_FragCoord.xy / resolution;
      float color = 0.5;
      color += sin(position.y * TAU * 0.6 + (time * 2.0)) * sin(position.x * TAU * 0.6 + (time * 2.0)) * 0.4;
      color += snoise(position.xy * 3.0 - (time * 0.5)) * 0.1;
      gl_FragColor = vec4(vec3(color), 1.0);
    }

  """

  VIEW_ANGLE = 20
  NEAR = 1
  FAR = 10000
  CAM_FACTOR = 4

  camera = null
  scene = null
  renderer = null

  heightCamera = null
  heightScene = null
  heightRenderTarget = null

  uniforms = null
  heightUniforms = null

  time = new Date().getSeconds()

  getScrollbarWidth = ->
    inner = document.createElement('p')
    inner.style.width = "100%"
    inner.style.height = "200px"
     
    outer = document.createElement('div')
    outer.style.position = "absolute"
    outer.style.top = "0px"
    outer.style.left = "0px"
    outer.style.visibility = "hidden"
    outer.style.width = "200px"
    outer.style.height = "150px"
    outer.style.overflow = "hidden"
    outer.appendChild(inner)
     
    document.body.appendChild(outer)
    w1 = inner.offsetWidth
    outer.style.overflow = 'scroll'
    w2 = inner.offsetWidth
     
    if w1 == w2
      w2 = outer.clientWidth
     
    document.body.removeChild(outer)
     
    return (w1 - w2)
  # scrollbarwidth = getScrollbarWidth()

  webGlSupported = ->
    try
      canvas = document.createElement('canvas')
      return !!(window.WebGLRenderingContext && (canvas.getContext('webgl')))
     catch e
       return false

  init = ->
    if not Modernizr.webgl then return
    if !webGlSupported() then return
    is_chrome = navigator.userAgent.toLowerCase().indexOf('chrome') > -1

    ###--------------------------------------------------------------------------
     init height map
    --------------------------------------------------------------------------###

    heightScene = new THREE.Scene()
    heightCamera = new THREE.Camera()
    heightCamera.position.z = 1
    heightUniforms =
      time:
        type: "f"
        value: time

    material = new THREE.ShaderMaterial
      uniforms: heightUniforms
      vertexShader: HEIGHT_VERTEX_SHADER
      fragmentShader: HEIGHT_FRAGMENT_SHADER

    heightScene.add new THREE.Mesh new THREE.PlaneBufferGeometry(2, 2), material

    heightRenderTarget = new THREE.WebGLRenderTarget 512, 512,
      minFilter: THREE.LinearFilter
      magFilter: THREE.NearestFilter
      format: THREE.RGBFormat


    ###--------------------------------------------------------------------------
     init main scene
    --------------------------------------------------------------------------###

    scene = new THREE.Scene()
    camera = new THREE.OrthographicCamera -width() / CAM_FACTOR, width() / CAM_FACTOR, height() / CAM_FACTOR, -height() / CAM_FACTOR, NEAR, FAR

    camera.position.y = 60
    camera.position.z = 200
    camera.lookAt new THREE.Vector3 0, 0, 0
    scene.add camera

    renderer = new THREE.WebGLRenderer
      antialias: true
      alpha: true
    renderer.setSize width(), height()
    canvas = $(renderer.domElement).hide().fadeIn(4000)
    canvas.addClass "noPrint"
    canvas.attr "id", "backgroundCanvas"
    $("body").append canvas

    uniforms =
      heightmap:
        type: 't'
        value: heightRenderTarget

    shaderMaterial = new THREE.ShaderMaterial
      uniforms: uniforms
      vertexShader: VERTEX_SHADER
      fragmentShader: FRAGMENT_SHADER

    geometry = new THREE.PlaneBufferGeometry 1000, 300, 100, 100
    plane = new THREE.Mesh geometry, shaderMaterial
    plane.rotation.x = -Math.PI / 2
    scene.add plane

    window.addEventListener 'resize', onWindowResize, false
    window.addEventListener 'scroll', onWindowResize, false
    animate()

  onWindowResize = ->
    renderer.setSize width(), height()
    camera.left = -width() / CAM_FACTOR
    camera.right = width() / CAM_FACTOR
    camera.top = height() / CAM_FACTOR
    camera.bottom = -height() / CAM_FACTOR
    camera.updateProjectionMatrix()

  animate = ->
    requestAnimationFrame animate
    render()

  width = ->
    $(window).width()# + scrollbarwidth # scrollbar offset

  height = ->
    window.innerHeight

  render = ->
    heightUniforms.time.value = time
    time += 0.002
    renderer.render heightScene, heightCamera, heightRenderTarget, true
    renderer.render scene, camera


  exports =
    init: init
